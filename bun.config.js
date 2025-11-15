import path from 'path';
import fs from 'fs';

const buildConfig = {
  sourcemap: process.env.NODE_ENV === "production" ? "none" : "external",
  entrypoints: [
    "app/javascript/application.js",
    "submodules/core/javascript/public_application.js",
    "submodules/core/javascript/application.js",
    "submodules/editor/src/main.tsx"  // Direct path to editor entry
  ],
  outdir: path.join(process.cwd(), "app/assets/builds"),
  target: "browser",
  format: "esm",
  splitting: false,
  minify: false,
  naming: {
    entry: '[dir]/[name].[ext]'
  }
};

const build = async (config) => {
  const result = await Bun.build(config);

  if (!result.success) {
    if (process.argv.includes('--watch')) {
      console.error("Build failed");
      for (const message of result.logs) {
        console.error(message);
      }
      return;
    } else {
      throw new AggregateError(result.logs, "Build failed");
    }
  }
  
  // Copy app/javascript/application.js to application.js in the root of builds
  const sourceFile = path.join(process.cwd(), "app/assets/builds/app/javascript/application.js");
  const targetFile = path.join(process.cwd(), "app/assets/builds/application.js");
  if (fs.existsSync(sourceFile)) {
    fs.copyFileSync(sourceFile, targetFile);
    console.log(`Copied ${sourceFile} to ${targetFile}`);
  }

  // Copy submodules/editor/src/main.js to editor.js in the root of builds
  const editorSourceFile = path.join(process.cwd(), "app/assets/builds/submodules/editor/src/main.js");
  const editorTargetFile = path.join(process.cwd(), "app/assets/builds/editor.js");
  if (fs.existsSync(editorSourceFile)) {
    fs.copyFileSync(editorSourceFile, editorTargetFile);
    console.log(`Copied ${editorSourceFile} to ${editorTargetFile}`);
  } else {
    console.error(`Editor source file not found: ${editorSourceFile}`);
  }
};

(async () => {
  await build(buildConfig);

  if (process.argv.includes('--watch')) {
    fs.watch(path.join(process.cwd(), "app/javascript"), { recursive: true }, (eventType, filename) => {
      console.log(`File changed: ${filename}. Rebuilding...`);
      build(buildConfig);
    });
    fs.watch(path.join(process.cwd(), "submodules/editor"), { recursive: true }, (eventType, filename) => {
      console.log(`File changed: ${filename}. Rebuilding...`);
      build(buildConfig);
    });
  } else {
    process.exit(0);
  }
})();

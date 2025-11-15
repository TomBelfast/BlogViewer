# Konfiguracja przechowywania plików w BlogBowl

## Problem
Po pobraniu aplikacji z repozytorium, dodawanie zdjęć może nie działać z kilku powodów:

## Rozwiązanie 1: Lokalne przechowywanie (Development)

Aplikacja jest już skonfigurowana do używania lokalnego dysku w trybie development. Upewnij się, że:

1. **Katalog storage istnieje i ma odpowiednie uprawnienia:**
   ```bash
   mkdir -p storage
   chmod 755 storage
   ```

2. **Active Storage jest już skonfigurowane:**
   - Routing: `/rails/active_storage/direct_uploads` (POST)
   - Konfiguracja: `config.active_storage.service = :local` w `config/environments/development.rb`
   - Katalog: `storage/` w głównym katalogu projektu

## Rozwiązanie 2: MinIO / S3 (Production - Opcjonalne)

Jeśli chcesz używać MinIO lub S3 do przechowywania plików (zalecane dla produkcji):

### Konfiguracja MinIO (S3-compatible)

1. **Zainstaluj i uruchom MinIO:**
   ```bash
   docker run -d \
     -p 9000:9000 \
     -p 9001:9001 \
     --name minio \
     -e "MINIO_ROOT_USER=minioadmin" \
     -e "MINIO_ROOT_PASSWORD=minioadmin" \
     -v /data/minio:/data \
     minio/minio server /data --console-address ":9001"
   ```

2. **Utwórz bucket w MinIO:**
   - Otwórz konsolę MinIO: http://localhost:9001
   - Zaloguj się (minioadmin/minioadmin)
   - Utwórz nowy bucket (np. `blogbowl-storage`)

3. **Skonfiguruj zmienne środowiskowe w `.env`:**
   ```env
   S3_ACCESS_KEY_ID=minioadmin
   S3_SECRET_ACCESS_KEY=minioadmin
   S3_ENDPOINT=http://localhost:9000
   S3_REGION=us-east-1
   S3_BUCKET=blogbowl-storage
   ```

4. **Zainstaluj gem aws-sdk-s3:**
   ```bash
   bundle add aws-sdk-s3
   ```

5. **Aplikacja automatycznie przełączy się na S3** jeśli zmienne środowiskowe są ustawione (sprawdza to w `config/environments/production.rb`)

## Sprawdzanie konfiguracji

### Test routingu Active Storage:
```bash
curl http://localhost:3000/rails/active_storage/disk/
```

### Test uploadu (wymaga autoryzacji):
```bash
curl -X POST http://localhost:3000/rails/active_storage/direct_uploads \
  -H "Content-Type: application/json" \
  -H "Cookie: _blogbowl_session=..." \
  -d '{"blob":{"filename":"test.jpg","content_type":"image/jpeg","byte_size":1024}}'
```

## Uwagi

- **Development**: Lokalne przechowywanie działa "out of the box" - nie wymaga dodatkowej konfiguracji
- **Production**: Zalecane jest użycie S3/MinIO dla lepszej wydajności i skalowalności
- **Routing**: Active Storage routing jest automatycznie montowany przez Rails Engine
- **API**: Endpoint `/rails/active_storage/direct_uploads` jest już dostępny

## Rozwiązywanie problemów

1. **Brak uprawnień do zapisu:**
   ```bash
   chmod -R 755 storage/
   ```

2. **Brak miejsca na dysku:**
   ```bash
   df -h storage/
   ```

3. **Sprawdzenie logów:**
   ```bash
   tail -f log/development.log | grep -i "storage\|upload\|attach"
   ```


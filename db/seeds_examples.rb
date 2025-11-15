# Przykładowe dane dla BlogBowl
# Uruchom przez: rails runner db/seeds_examples.rb

puts "Tworzenie przykładowych danych..."

workspace = Workspace.first
author = Author.first
page1 = Page.find_by(domain: 'localhost')
page2 = Page.find_by(domain: 'blog.aihub.ovh')

# Przykładowe posty dla "My blog"
if page1
  puts "\nTworzenie postów dla 'My blog'..."
  
  post1 = Post.new(
    page: page1,
    title: "Witaj na moim blogu!",
    slug: "witaj-na-moim-blogu",
    content_html: "<h1>Witaj na moim blogu!</h1><p>To jest mój pierwszy post na blogu BlogBowl. BlogBowl to potężne narzędzie do zarządzania treścią blogową.</p><h2>Funkcje BlogBowl</h2><ul><li>Łatwe zarządzanie postami</li><li>Wsparcie dla wielu autorów</li><li>System newsletterów</li><li>Responsywny design</li></ul><p>Zapraszam do regularnego odwiedzania!</p>",
    content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Witaj na moim blogu!"}]},{"type":"paragraph","content":[{"type":"text","text":"To jest mój pierwszy post na blogu BlogBowl. BlogBowl to potężne narzędzie do zarządzania treścią blogową."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Funkcje BlogBowl"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Łatwe zarządzanie postami"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Wsparcie dla wielu autorów"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"System newsletterów"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Responsywny design"}]}]}]},{"type":"paragraph","content":[{"type":"text","text":"Zapraszam do regularnego odwiedzania!"}]}]},
    description: "Pierwszy post na blogu przedstawiający BlogBowl",
    status: 1, # published
    seo_title: "Witaj na moim blogu - BlogBowl",
    seo_description: "Pierwszy post na blogu BlogBowl przedstawiający funkcje platformy",
    first_published_at: Time.current
  )
  post1.authors << author
  post1.save!
  
  post2 = Post.new(
    page: page1,
    title: "Jak zacząć korzystać z BlogBowl",
    slug: "jak-zaczac-korzystac-z-blogbowl",
    content_html: "<h1>Jak zacząć korzystać z BlogBowl</h1><p>BlogBowl to nowoczesna platforma do zarządzania blogami. W tym poście pokażemy Ci jak rozpocząć pracę.</p><h2>Kroki początkowe</h2><ol><li>Zaloguj się do panelu administracyjnego</li><li>Utwórz swoją pierwszą stronę</li><li>Dodaj pierwszego autora</li><li>Zacznij pisać posty!</li></ol><h2>Wskazówki</h2><p>Pamiętaj, że możesz tworzyć wiele stron i zarządzać nimi z jednego miejsca. Każda strona może mieć własną domenę i ustawienia.</p>",
    content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Jak zacząć korzystać z BlogBowl"}]},{"type":"paragraph","content":[{"type":"text","text":"BlogBowl to nowoczesna platforma do zarządzania blogami. W tym poście pokażemy Ci jak rozpocząć pracę."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Kroki początkowe"}]},{"type":"orderedList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Zaloguj się do panelu administracyjnego"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Utwórz swoją pierwszą stronę"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Dodaj pierwszego autora"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Zacznij pisać posty!"}]}]}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Wskazówki"}]},{"type":"paragraph","content":[{"type":"text","text":"Pamiętaj, że możesz tworzyć wiele stron i zarządzać nimi z jednego miejsca. Każda strona może mieć własną domenę i ustawienia."}]}]},
    description: "Przewodnik po rozpoczęciu pracy z BlogBowl",
    status: 1,
    seo_title: "Jak zacząć korzystać z BlogBowl - Przewodnik",
    seo_description: "Dowiedz się jak rozpocząć pracę z BlogBowl - nowoczesną platformą do zarządzania blogami",
    first_published_at: 1.day.ago
  )
  post2.authors << author
  post2.save!
  
  post3 = Post.new(
    page: page1,
    title: "Najlepsze praktyki SEO dla blogów",
    slug: "najlepsze-praktyki-seo-dla-blogow",
    content_html: "<h1>Najlepsze praktyki SEO dla blogów</h1><p>Optymalizacja pod kątem wyszukiwarek (SEO) jest kluczowa dla sukcesu każdego bloga. Oto kilka wskazówek:</p><h2>1. Używaj odpowiednich nagłówków</h2><p>Nagłówki H1, H2, H3 pomagają wyszukiwarkom zrozumieć strukturę Twojej treści.</p><h2>2. Optymalizuj meta opisy</h2><p>Każdy post powinien mieć unikalny meta opis, który zachęci użytkowników do kliknięcia.</p><h2>3. Dodawaj obrazy z alt text</h2><p>Obrazy z odpowiednimi opisami alt pomagają w SEO i dostępności.</p><h2>4. Twórz wartościową treść</h2><p>Najważniejsze jest tworzenie wartościowej, oryginalnej treści, która odpowiada na pytania użytkowników.</p>",
    content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Najlepsze praktyki SEO dla blogów"}]},{"type":"paragraph","content":[{"type":"text","text":"Optymalizacja pod kątem wyszukiwarek (SEO) jest kluczowa dla sukcesu każdego bloga. Oto kilka wskazówek:"}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"1. Używaj odpowiednich nagłówków"}]},{"type":"paragraph","content":[{"type":"text","text":"Nagłówki H1, H2, H3 pomagają wyszukiwarkom zrozumieć strukturę Twojej treści."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"2. Optymalizuj meta opisy"}]},{"type":"paragraph","content":[{"type":"text","text":"Każdy post powinien mieć unikalny meta opis, który zachęci użytkowników do kliknięcia."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"3. Dodawaj obrazy z alt text"}]},{"type":"paragraph","content":[{"type":"text","text":"Obrazy z odpowiednimi opisami alt pomagają w SEO i dostępności."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"4. Twórz wartościową treść"}]},{"type":"paragraph","content":[{"type":"text","text":"Najważniejsze jest tworzenie wartościowej, oryginalnej treści, która odpowiada na pytania użytkowników."}]}]},
    description: "Praktyczne wskazówki dotyczące optymalizacji SEO dla blogów",
    status: 1,
    seo_title: "Najlepsze praktyki SEO dla blogów - Przewodnik",
    seo_description: "Dowiedz się jak optymalizować swój blog pod kątem wyszukiwarek internetowych",
    first_published_at: 2.days.ago
  )
  post3.authors << author
  post3.save!
  
  puts "Utworzono #{Post.where(page: page1).count} postów dla 'My blog'"
end

# Przykładowe posty dla "AI Hub Blog"
if page2
  puts "\nTworzenie postów dla 'AI Hub Blog'..."
  
  post4 = Post.new(
    page: page2,
    title: "Wprowadzenie do sztucznej inteligencji",
    slug: "wprowadzenie-do-sztucznej-inteligencji",
    content_html: "<h1>Wprowadzenie do sztucznej inteligencji</h1><p>Sztuczna inteligencja (AI) rewolucjonizuje sposób, w jaki żyjemy i pracujemy. W tym poście przedstawimy podstawowe koncepcje AI.</p><h2>Co to jest AI?</h2><p>Sztuczna inteligencja to dziedzina informatyki zajmująca się tworzeniem systemów zdolnych do wykonywania zadań wymagających ludzkiej inteligencji.</p><h2>Główne obszary AI</h2><ul><li><strong>Machine Learning</strong> - uczenie maszynowe</li><li><strong>Deep Learning</strong> - głębokie uczenie</li><li><strong>Natural Language Processing</strong> - przetwarzanie języka naturalnego</li><li><strong>Computer Vision</strong> - widzenie komputerowe</li></ul><h2>Zastosowania AI</h2><p>AI znajduje zastosowanie w wielu dziedzinach: medycynie, transporcie, finansach, rozrywce i wielu innych.</p>",
    content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Wprowadzenie do sztucznej inteligencji"}]},{"type":"paragraph","content":[{"type":"text","text":"Sztuczna inteligencja (AI) rewolucjonizuje sposób, w jaki żyjemy i pracujemy. W tym poście przedstawimy podstawowe koncepcje AI."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Co to jest AI?"}]},{"type":"paragraph","content":[{"type":"text","text":"Sztuczna inteligencja to dziedzina informatyki zajmująca się tworzeniem systemów zdolnych do wykonywania zadań wymagających ludzkiej inteligencji."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Główne obszary AI"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"Machine Learning"},{"type":"text","text":" - uczenie maszynowe"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"Deep Learning"},{"type":"text","text":" - głębokie uczenie"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"Natural Language Processing"},{"type":"text","text":" - przetwarzanie języka naturalnego"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"Computer Vision"},{"type":"text","text":" - widzenie komputerowe"}]}]}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Zastosowania AI"}]},{"type":"paragraph","content":[{"type":"text","text":"AI znajduje zastosowanie w wielu dziedzinach: medycynie, transporcie, finansach, rozrywce i wielu innych."}]}]},
    description: "Podstawowe wprowadzenie do świata sztucznej inteligencji",
    status: 1,
    seo_title: "Wprowadzenie do sztucznej inteligencji - AI Hub Blog",
    seo_description: "Dowiedz się czym jest sztuczna inteligencja i jak zmienia nasz świat",
    first_published_at: 3.days.ago
  )
  post4.authors << author
  post4.save!
  
  post5 = Post.new(
    page: page2,
    title: "Machine Learning w praktyce",
    slug: "machine-learning-w-praktyce",
    content_html: "<h1>Machine Learning w praktyce</h1><p>Machine Learning to jeden z najważniejszych obszarów sztucznej inteligencji. W tym artykule pokażemy jak zastosować ML w rzeczywistych projektach.</p><h2>Popularne biblioteki ML</h2><ul><li><strong>TensorFlow</strong> - stworzona przez Google</li><li><strong>PyTorch</strong> - rozwijana przez Facebook</li><li><strong>Scikit-learn</strong> - idealna dla początkujących</li></ul><h2>Przykłady zastosowań</h2><p>Machine Learning może być używany do:</p><ul><li>Rozpoznawania obrazów</li><li>Przetwarzania języka naturalnego</li><li>Rekomendacji produktów</li><li>Predykcji trendów</li></ul><h2>Jak zacząć?</h2><p>Najlepszym sposobem na rozpoczęcie przygody z ML jest praktyka. Zacznij od prostych projektów i stopniowo zwiększaj złożoność.</p>",
    content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Machine Learning w praktyce"}]},{"type":"paragraph","content":[{"type":"text","text":"Machine Learning to jeden z najważniejszych obszarów sztucznej inteligencji. W tym artykule pokażemy jak zastosować ML w rzeczywistych projektach."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Popularne biblioteki ML"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"TensorFlow"},{"type":"text","text":" - stworzona przez Google"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"PyTorch"},{"type":"text","text":" - rozwijana przez Facebook"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","marks":[{"type":"bold"}],"text":"Scikit-learn"},{"type":"text","text":" - idealna dla początkujących"}]}]}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Przykłady zastosowań"}]},{"type":"paragraph","content":[{"type":"text","text":"Machine Learning może być używany do:"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Rozpoznawania obrazów"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Przetwarzania języka naturalnego"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Rekomendacji produktów"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Predykcji trendów"}]}]}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Jak zacząć?"}]},{"type":"paragraph","content":[{"type":"text","text":"Najlepszym sposobem na rozpoczęcie przygody z ML jest praktyka. Zacznij od prostych projektów i stopniowo zwiększaj złożoność."}]}]},
    description: "Praktyczny przewodnik po Machine Learning",
    status: 1,
    seo_title: "Machine Learning w praktyce - Przewodnik",
    seo_description: "Dowiedz się jak zastosować Machine Learning w rzeczywistych projektach",
    first_published_at: 4.days.ago
  )
  post5.authors << author
  post5.save!
  
  puts "Utworzono #{Post.where(page: page2).count} postów dla 'AI Hub Blog'"
end

# Przykładowe newslettery
puts "\nTworzenie newsletterów..."

newsletter1 = Newsletter.find_or_create_by(name_slug: "glowny-newsletter") do |n|
  n.workspace = workspace
  n.name = "Główny Newsletter"
end
newsletter1.save(validate: false)

newsletter2 = Newsletter.find_or_create_by(name_slug: "ai-updates") do |n|
  n.workspace = workspace
  n.name = "AI Updates"
end
newsletter2.save(validate: false)

puts "Utworzono #{Newsletter.count} newsletterów"

# Przykładowi subskrybenci
puts "\nTworzenie przykładowych subskrybentów..."

# Subskrybenci dla "Główny Newsletter"
subscribers1 = [
  { email: "jan.kowalski@example.com", verified: true, active: true, country: "Poland", city: "Warsaw" },
  { email: "anna.nowak@example.com", verified: true, active: true, country: "Poland", city: "Krakow" },
  { email: "piotr.wisniewski@example.com", verified: true, active: true, country: "Poland", city: "Gdansk" },
  { email: "maria.wojcik@example.com", verified: false, active: true, country: "Poland", city: "Wroclaw" },
  { email: "tomasz.kowalczyk@example.com", verified: true, active: true, country: "Poland", city: "Poznan" }
]

subscribers1.each do |sub_data|
  subscriber = newsletter1.subscribers.find_or_initialize_by(email: sub_data[:email])
  subscriber.assign_attributes(
    verified: sub_data[:verified],
    active: sub_data[:active],
    status: sub_data[:verified] ? 'active' : 'pending',
    country: sub_data[:country],
    city: sub_data[:city],
    verified_at: sub_data[:verified] ? Time.current : nil,
    deliver_count: rand(5..20),
    open_count: rand(3..15),
    click_count: rand(1..10)
  )
  subscriber.save(validate: false)
end

# Subskrybenci dla "AI Updates"
subscribers2 = [
  { email: "ai.enthusiast@example.com", verified: true, active: true, country: "USA", city: "San Francisco" },
  { email: "ml.researcher@example.com", verified: true, active: true, country: "UK", city: "London" },
  { email: "data.scientist@example.com", verified: true, active: true, country: "Germany", city: "Berlin" },
  { email: "tech.innovator@example.com", verified: false, active: true, country: "Canada", city: "Toronto" }
]

subscribers2.each do |sub_data|
  subscriber = newsletter2.subscribers.find_or_initialize_by(email: sub_data[:email])
  subscriber.assign_attributes(
    verified: sub_data[:verified],
    active: sub_data[:active],
    status: sub_data[:verified] ? 'active' : 'pending',
    country: sub_data[:country],
    city: sub_data[:city],
    verified_at: sub_data[:verified] ? Time.current : nil,
    deliver_count: rand(3..15),
    open_count: rand(2..12),
    click_count: rand(1..8)
  )
  subscriber.save(validate: false)
end

puts "Utworzono #{Subscriber.count} subskrybentów"
puts "  - Dla 'Główny Newsletter': #{newsletter1.subscribers.count} subskrybentów"
puts "  - Dla 'AI Updates': #{newsletter2.subscribers.count} subskrybentów"

# Przykładowe emaile newslettera
puts "\nTworzenie przykładowych emaili newslettera..."

# Email dla "Główny Newsletter"
email1 = NewsletterEmail.new(
  newsletter: newsletter1,
  author: author,
  subject: "Witamy w naszym newsletterze!",
  preview: "Pierwszy newsletter z najnowszymi wiadomościami",
  content_html: "<h1>Witamy w naszym newsletterze!</h1><p>Dziękujemy za subskrypcję. Oto najnowsze wiadomości z naszego bloga.</p><h2>Najnowsze posty</h2><ul><li>Witaj na moim blogu!</li><li>Jak zacząć korzystać z BlogBowl</li><li>Najlepsze praktyki SEO dla blogów</li></ul><p>Zapraszamy do regularnego odwiedzania!</p>",
  content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Witamy w naszym newsletterze!"}]},{"type":"paragraph","content":[{"type":"text","text":"Dziękujemy za subskrypcję. Oto najnowsze wiadomości z naszego bloga."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Najnowsze posty"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Witaj na moim blogu!"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Jak zacząć korzystać z BlogBowl"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Najlepsze praktyki SEO dla blogów"}]}]}]},{"type":"paragraph","content":[{"type":"text","text":"Zapraszamy do regularnego odwiedzania!"}]}]},
  status: 'sent',
  sent_at: 2.days.ago,
  deliver_count: 5,
  open_count: 4,
  click_count: 3
)
email1.save(validate: false)

email2 = NewsletterEmail.new(
  newsletter: newsletter1,
  author: author,
  subject: "Najnowsze aktualizacje - Listopad 2024",
  preview: "Zobacz co nowego w BlogBowl",
  content_html: "<h1>Najnowsze aktualizacje - Listopad 2024</h1><p>W tym miesiącu mamy dla Was wiele ciekawych informacji!</p><h2>Nowe funkcje</h2><p>Dodaliśmy wiele nowych funkcji, które ułatwią zarządzanie blogiem.</p><h2>Przypomnienie</h2><p>Pamiętajcie o regularnym publikowaniu treści!</p>",
  content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Najnowsze aktualizacje - Listopad 2024"}]},{"type":"paragraph","content":[{"type":"text","text":"W tym miesiącu mamy dla Was wiele ciekawych informacji!"}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Nowe funkcje"}]},{"type":"paragraph","content":[{"type":"text","text":"Dodaliśmy wiele nowych funkcji, które ułatwią zarządzanie blogiem."}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Przypomnienie"}]},{"type":"paragraph","content":[{"type":"text","text":"Pamiętajcie o regularnym publikowaniu treści!"}]}]},
  status: 'draft',
  deliver_count: 0,
  open_count: 0,
  click_count: 0
)
email2.save(validate: false)

# Email dla "AI Updates"
email3 = NewsletterEmail.new(
  newsletter: newsletter2,
  author: author,
  subject: "Najnowsze trendy w AI - Listopad 2024",
  preview: "Przegląd najważniejszych wydarzeń ze świata sztucznej inteligencji",
  content_html: "<h1>Najnowsze trendy w AI</h1><p>Witamy w naszym newsletterze o sztucznej inteligencji!</p><h2>Najnowsze posty</h2><ul><li>Wprowadzenie do sztucznej inteligencji</li><li>Machine Learning w praktyce</li></ul><p>Zapraszamy do lektury!</p>",
  content_json: {"type":"doc","content":[{"type":"heading","attrs":{"level":1},"content":[{"type":"text","text":"Najnowsze trendy w AI"}]},{"type":"paragraph","content":[{"type":"text","text":"Witamy w naszym newsletterze o sztucznej inteligencji!"}]},{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Najnowsze posty"}]},{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Wprowadzenie do sztucznej inteligencji"}]}]},{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"Machine Learning w praktyce"}]}]}]},{"type":"paragraph","content":[{"type":"text","text":"Zapraszamy do lektury!"}]}]},
  status: 'sent',
  sent_at: 1.day.ago,
  deliver_count: 4,
  open_count: 3,
  click_count: 2
)
email3.save(validate: false)

puts "Utworzono #{NewsletterEmail.count} emaili newslettera"
puts "  - Dla 'Główny Newsletter': #{newsletter1.newsletter_emails.count} emaili"
puts "  - Dla 'AI Updates': #{newsletter2.newsletter_emails.count} emaili"

puts "\n✅ Przykładowe dane zostały utworzone pomyślnie!"
puts "\nPodsumowanie:"
puts "  - Posty dla 'My blog': #{Post.where(page: page1).count}" if page1
puts "  - Posty dla 'AI Hub Blog': #{Post.where(page: page2).count}" if page2
puts "  - Newslettery: #{Newsletter.count}"
puts "  - Subskrybenci: #{Subscriber.count}"
puts "  - Emaile newslettera: #{NewsletterEmail.count}"


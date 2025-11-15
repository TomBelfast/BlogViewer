# Podsumowanie instalacji BlogBowl

## ✅ Zakończone pomyślnie:

1. **Ruby 3.2.2** - zainstalowany przez rbenv
2. **Bun** - zainstalowany
3. **PostgreSQL 15** - uruchomiony w Dockerze na porcie 5435
4. **Redis** - uruchomiony w Dockerze na porcie 6380
5. **Zależności Ruby** - zainstalowane (bundle install)
6. **Baza danych** - utworzona i zmigrowana
7. **Seed danych** - wykonany (użytkownik admin@example.com / changeme)
8. **Aplikacja Rails** - uruchomiona na porcie 3000

## ⚠️ Znane problemy:

1. **Pakiety TipTap Pro** - wymagają licencji premium i nie mogą być zainstalowane bez tokenu autoryzacyjnego. To może powodować problemy z edytorem w interfejsie.

## 🚀 Jak uruchomić aplikację:

```bash
cd /root/BlogBowl
export PATH="$HOME/.rbenv/bin:$HOME/.bun/bin:$PATH"
eval "$(rbenv init - bash)"

# Uruchom PostgreSQL i Redis
docker compose -f docker-compose.dev.yaml up -d

# Uruchom aplikację w trybie developerskim
bundle exec foreman start -f Procfile.dev
```

Aplikacja będzie dostępna pod adresem: http://localhost:3000

## 🔐 Domyślne dane logowania:

- Email: admin@example.com
- Hasło: changeme

**UWAGA:** Zmień hasło po pierwszym logowaniu!

## 📝 Uwagi:

- Aplikacja może zwracać błędy związane z brakującymi pakietami TipTap Pro
- Frontend może wymagać dodatkowej konfiguracji dla pakietów premium
- Wszystkie usługi (PostgreSQL, Redis) działają w Dockerze, aplikacja Rails lokalnie

# Instrukcja wypchnięcia kodu do GitHub

## Repozytorium docelowe
**URL:** https://github.com/TomBelfast/BlogViewer

## Metoda 1: Użycie Personal Access Token (Polecane)

1. **Utwórz Personal Access Token:**
   - Przejdź do: https://github.com/settings/tokens
   - Kliknij "Generate new token (classic)"
   - Wybierz scope: `repo` (pełna kontrola repozytoriów)
   - Wygeneruj i skopiuj token (zaczyna się od `ghp_`)

2. **Wypchnij kod używając tokena:**
   ```bash
   cd /root/BlogBowl
   git remote set-url origin https://<TWÓJ_TOKEN>@github.com/TomBelfast/BlogViewer.git
   git push -u origin main
   ```

   **Lub użyj zmiennej środowiskowej:**
   ```bash
   cd /root/BlogBowl
   GIT_ASKPASS=echo git push -u origin main <<< <TWÓJ_TOKEN>
   ```

## Metoda 2: Użycie SSH (Jeśli masz skonfigurowany klucz SSH)

1. **Zmień remote na SSH:**
   ```bash
   cd /root/BlogBowl
   git remote set-url origin git@github.com:TomBelfast/BlogViewer.git
   git push -u origin main
   ```

## Metoda 3: Ręczne uwierzytelnienie

1. **Wykonaj push i wprowadź dane:**
   ```bash
   cd /root/BlogBowl
   git push -u origin main
   ```
   - Username: `TomBelfast`
   - Password: `<TWÓJ_TOKEN>` (nie hasło GitHub!)

## Sprawdzenie statusu

Po udanym pushu, sprawdź repozytorium:
https://github.com/TomBelfast/BlogViewer



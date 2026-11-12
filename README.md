# ERPSC-2627-igdb-fe-JH

Fiori Elements (OData V4) applicatie bovenop de CAP IGDB back-end — opdracht *ERP System Configuration 2026-2027* (HOGENT).
Auteur: **Jasper Huyghe**

## Wat zit erin

| Pagina | Floorplan | Functionaliteit |
|---|---|---|
| Overzicht studenten | List Report | Zoeken + filteren op voor-/achternaam, aanmaken, verwijderen, navigeren naar detail |
| Detail student | Object Page | Voor-/achternaam bewerken, lijst van favoriete games (cover, genre, platform, uitgever, releasedatum) |
| Favoriete games (nice-to-have) | Tabel op de Object Page | Games toevoegen (type-ahead of waardehulp-dialoog met alle 500 games) en verwijderen |

Bewerken gebeurt via **draft** (`@odata.draft.enabled` op `GameService.Student`); de compositie `to_favos` gaat automatisch mee in de draft.

## Starten

```bash
npm install
npm run watch-students      # = cds watch --open igdb.students/index.html
```

App: <http://localhost:4004/igdb.students/index.html>

De UI5-bibliotheken (SAPUI5 1.142) worden lokaal geserveerd via `cds-plugin-ui5` + UI5 Tooling (`app/students/ui5.yaml`).

## Projectstructuur

```
app/
  services.cds                 -> laadt de UI-annotaties
  students/
    annotations.cds            -> LineItem, HeaderInfo, Facets, FieldGroup, ValueList, SideEffects
    ui5.yaml / package.json    -> UI5 tooling configuratie
    webapp/
      manifest.json            -> routing List Report <-> Object Page, tabelinstellingen
      Component.js, index.html, i18n/
db/schema.cds                  -> datamodel
srv/game-service.cds           -> service + draft enablement
srv/game-service.js            -> validatie bij opslaan (verplichte velden, geen dubbele games)
test/requests.http             -> voorbeeld-requests (draft-flow)
```

## Wijzigingen aan de back-end

* `Student` is draft-enabled.
* `FavoriteGame` kreeg een technische sleutel `ID : UUID` (i.p.v. de samengestelde sleutel `Game_ID + Student_ID`).
  Met een niet-gegenereerde sleutel kan Fiori Elements in draft-modus geen nieuwe rij aanmaken
  (`NOT NULL constraint failed: ...FavoriteGame_drafts.Game_ID`). `Game_ID` is nu een gewoon (verplicht) veld met waardehulp.
* Validatie in `srv/game-service.js`: voornaam/achternaam verplicht, elke favoriet moet een bestaande game zijn en mag maar één keer voorkomen.

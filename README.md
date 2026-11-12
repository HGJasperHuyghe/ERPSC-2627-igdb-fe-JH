# ERPSC-2627-igdb-fe-JH

Opdracht *ERP System Configuration 2026-2027* (HOGENT).
Auteur: **Jasper Huyghe**

## Starten

```bash
npm install
npm run watch-students      # = cds watch --open igdb.students/index.html
```

App: <http://localhost:4004/igdb.students/index.html>

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

* AI Generated

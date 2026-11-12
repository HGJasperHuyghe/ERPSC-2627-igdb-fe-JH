using GameService as service from '../../srv/game-service';

// ---------------------------------------------------------------------------
// Labels
// ---------------------------------------------------------------------------
annotate service.Student with {
  Student_ID @title: 'Student ID'  @UI.Hidden;
  First_name @title: 'Voornaam'    @mandatory;
  Last_name  @title: 'Achternaam'  @mandatory;
};

annotate service.Game with {
  Game_ID      @title: 'Game ID'  @Common.Text: Name  @Common.TextArrangement: #TextFirst;
  Name         @title: 'Naam';
  Genre        @title: 'Genre';
  Publisher    @title: 'Uitgever';
  Platform     @title: 'Platform';
  Release_date @title: 'Releasedatum';
  Cover_url    @title: 'Cover'  @UI.IsImageURL;
  Description  @title: 'Beschrijving'  @UI.MultiLineText;
};

annotate service.FavoriteGame with {
  ID         @UI.Hidden;
  Student_ID @UI.Hidden;
  Game_ID    @title: 'Game'
             @Common: {
               Text           : to_game.Name,
               TextArrangement: #TextOnly,
               ValueListWithFixedValues: false,
               ValueList      : {
                 Label         : 'Games',
                 CollectionPath: 'Game',
                 Parameters    : [
                   { $Type: 'Common.ValueListParameterInOut',         LocalDataProperty: Game_ID, ValueListProperty: 'Game_ID' },
                   { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Name' },
                   { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Genre' },
                   { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Platform' },
                   { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'Release_date' }
                 ]
               }
             };
};

// ---------------------------------------------------------------------------
// Pagina 1: List Report – overzicht van alle studenten
// ---------------------------------------------------------------------------
annotate service.Student with @(
  UI.HeaderInfo      : {
    TypeName      : 'Student',
    TypeNamePlural: 'Studenten',
    Title         : { Value: First_name },
    Description   : { Value: Last_name },
    TypeImageUrl  : 'sap-icon://person-placeholder'
  },
  UI.SelectionFields : [ First_name, Last_name ],
  UI.LineItem        : [
    { Value: First_name, ![@HTML5.CssDefaults]: { width: '20rem' } },
    { Value: Last_name,  ![@HTML5.CssDefaults]: { width: '20rem' } }
  ],

  // -------------------------------------------------------------------------
  // Pagina 2: Object Page – detail van één student + favoriete games
  // -------------------------------------------------------------------------
  UI.FieldGroup #General : {
    Label: 'Persoonsgegevens',
    Data : [
      { Value: First_name },
      { Value: Last_name }
    ]
  },
  UI.Facets          : [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'GeneralFacet',
      Label : 'Algemeen',
      Target: '@UI.FieldGroup#General'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'FavoritesFacet',
      Label : 'Favoriete games',
      Target: 'to_favos/@UI.LineItem'
    }
  ]
);

annotate service.FavoriteGame with @(
  UI.HeaderInfo: {
    TypeName      : 'Favoriete game',
    TypeNamePlural: 'Favoriete games',
    Title         : { Value: to_game.Name }
  },
  UI.LineItem  : [
    { Value: to_game.Cover_url,    Label: 'Cover' },
    { Value: Game_ID },
    { Value: to_game.Genre,        Label: 'Genre' },
    { Value: to_game.Platform,     Label: 'Platform' },
    { Value: to_game.Publisher,    Label: 'Uitgever' },
    { Value: to_game.Release_date, Label: 'Releasedatum' }
  ]
);

// Na het kiezen van een game meteen genre, platform, ... van die game ophalen
annotate service.FavoriteGame with @Common.SideEffects #GameChanged: {
  SourceProperties  : [ Game_ID ],
  TargetEntities    : [ to_game ]
};

namespace sap.igdbfe.cap;

entity Game {
  key Game_ID      : Integer;
      Name         : String(100);
      Genre        : String(50);
      Publisher    : String(50);
      Platform     : String(50);
      Release_date : Date;
      Cover_url    : String(100);
      Description  : LargeString;
}

entity Student {
  key Student_ID : UUID;
      First_name : String(100);
      Last_name  : String(100);
      to_favos   : Composition of many FavoriteGame
                     on to_favos.Student_ID = $self.Student_ID;
}

entity FavoriteGame {
  key ID         : UUID; // technische sleutel: nodig om in draft-modus nieuwe favorieten te kunnen aanmaken
      Game_ID    : Integer @mandatory;
      Student_ID : UUID;
      to_game    : Association to Game
                     on to_game.Game_ID = $self.Game_ID;
}

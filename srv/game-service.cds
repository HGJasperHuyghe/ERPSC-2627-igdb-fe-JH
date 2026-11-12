using {sap.igdbfe.cap as my} from '../db/schema';

service GameService {
  entity Game @readonly as projection on my.Game;
  entity Student        as projection on my.Student;
  entity FavoriteGame   as projection on my.FavoriteGame;

}

// Draft maakt Student (en via de compositie ook FavoriteGame) editeerbaar in Fiori Elements
annotate GameService.Student with @odata.draft.enabled;

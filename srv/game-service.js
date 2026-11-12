const cds = require('@sap/cds');

module.exports = class GameService extends cds.ApplicationService {
  init() {
    const { Student, Game } = this.entities;

    // Validatie bij het opslaan (activeren) van een student-draft
    this.before('SAVE', Student, async (req) => {
      const { First_name, Last_name, to_favos = [] } = req.data;
      if (!First_name?.trim()) req.error(400, 'Voornaam is verplicht', 'in/First_name');
      if (!Last_name?.trim()) req.error(400, 'Achternaam is verplicht', 'in/Last_name');

      const seen = new Set();
      for (const fav of to_favos) {
        const target = `in/to_favos(ID=${fav.ID},IsActiveEntity=false)/Game_ID`;
        if (fav.Game_ID == null) {
          req.error(400, 'Kies een game voor elke favoriet', target);
          continue;
        }
        if (seen.has(fav.Game_ID)) req.error(400, 'Deze game staat al bij de favorieten', target);
        seen.add(fav.Game_ID);
        const exists = await SELECT.one.from(Game).columns('Game_ID').where({ Game_ID: fav.Game_ID });
        if (!exists) req.error(400, `Game ${fav.Game_ID} bestaat niet`, target);
      }
    });

    return super.init();
  }
};

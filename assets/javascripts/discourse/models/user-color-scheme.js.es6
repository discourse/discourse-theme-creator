import ColorScheme from 'admin/models/color-scheme';
import { ajax } from 'discourse/lib/ajax';

export default ColorScheme.extend({

  save(){
    var data = {};

    data.colors = [];
    this.get('colors').forEach((c) => {
      if (c.get('changed')) {
        data.colors.pushObject({name: c.get('name'), hex: c.get('hex')});
      }
    });

    const theme_id = this.get('theme_id');
    const this_id = this.get('id');

    return ajax(`/user_themes/${theme_id}/colors/${this_id}`, {
      data: JSON.stringify({"color_scheme": data}),
      type: 'PUT',
      dataType: 'json',
      contentType: 'application/json'
    }).then(() => {
      this.startTrackingChanges();
      this.get('colors').forEach((c) => {
        c.startTrackingChanges();
      });
    });
  },

});

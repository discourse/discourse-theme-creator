import Theme from 'admin/models/theme';
import { default as computed } from 'ember-addons/ember-computed-decorators';

const FIELDS_IDS = [0, 1, 5];

export default Theme.extend({
  @computed('theme_fields')
  themeFields(fields) {

    if (!fields) {
      this.set('theme_fields', []);
      return {};
    }

    let hash = {};
    fields.forEach(field => {
      if (!field.type_id || FIELDS_IDS.includes(field.type_id)) {
        hash[this.getKey(field)] = field;
      }
    });
    return hash;
  },
});
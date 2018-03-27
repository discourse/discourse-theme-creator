import { default as computed, observes } from 'ember-addons/ember-computed-decorators';
import { url } from 'discourse/lib/computed';
import AdminCustomizeThemesEdit from 'admin/controllers/admin-customize-themes-edit';

export default AdminCustomizeThemesEdit.extend({
  previewUrl: url('model.id', '/user_themes/%@/preview'),

  @computed('onlyOverridden')
  showSettings() {
    return this.shouldShow('settings');
  },

  saveButtonText: function() {
    return this.get('model.isSaving') ? I18n.t('saving') : I18n.t('theme-creator.save');
  }.property('model.isSaving'),

  @computed("currentTargetName", "onlyOverridden")
  fields(target, onlyOverridden) {
    let fields = this.fieldsForTarget(target);

    if (onlyOverridden) {
      const model = this.get("model");
      const targetName = this.get("currentTargetName");
      fields = fields.filter(name => model.hasEdited(targetName, name));
    }

    return fields.map(name=>{
      let hash = {
        key: (`theme-creator.${name}.text`),
        name: name
      };

      if (name.indexOf("_tag") > 0) {
        hash.icon = "file-text-o";
      }

      hash.title = I18n.t(`theme-creator.${name}.title`);

      return hash;
    });
  },

  @observes('onlyOverridden')
  onlyOverriddenChanged() {
    if (this.get('onlyOverridden')) {
      if (!this.get('model').hasEdited(this.get('currentTargetName'), this.get('fieldName'))) {
        let target = (this.get('showCommon') && 'common') ||
          (this.get('showDesktop') && 'desktop') ||
          (this.get('showMobile') && 'mobile');

        let fields = this.get('model.theme_fields');
        let field = fields && fields.find(f => (f.target === target));
        this.replaceRoute('user.themes.edit', this.get('model.id'), target, field && field.name);
      }
    }
  },

  // actions:{
  //   save() {
  //     this.set('saving', true);
  //     this.get('model').saveChanges("theme_fields").finally(()=>{this.set('saving', false);});
  //   },
  // }

});

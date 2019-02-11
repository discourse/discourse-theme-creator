import { url } from "discourse/lib/computed";
import { default as computed } from "ember-addons/ember-computed-decorators";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import showModal from "discourse/lib/show-modal";
import AdminCustomizeThemesShowController from "admin/controllers/admin-customize-themes-show";
import ThemesColors from "discourse/plugins/discourse-theme-creator/discourse/mixins/themes-colors";

export default AdminCustomizeThemesShowController.extend(ThemesColors, {
  parentController: Ember.Object.create({ model: { content: [] } }),
  id: Ember.computed.alias("model.id"),
  colors: Ember.computed.alias("quickColorScheme.colors"),

  editRouteName: "user.themes.edit",

  @computed("model.color_scheme_id")
  colorSchemeEditDisabled(colorSchemeId) {
    return colorSchemeId === null;
  },

  downloadUrl: url("model.id", "/user_themes/%@/export"),

  @computed(
    "advancedOverride",
    "colorSchemes",
    "model.uploads",
    "model.hasEditedFields",
    "model.component"
  )
  showAdvanced(
    advancedOverride,
    colorSchemes,
    uploads,
    hasEditedFields,
    component
  ) {
    return (
      advancedOverride ||
      uploads.length > 0 ||
      colorSchemes.length > 2 ||
      hasEditedFields ||
      component
    );
  },

  advancedOverride: false,

  @computed("quickColorScheme")
  hasQuickColorScheme(scheme) {
    return !!scheme;
  },

  @computed("showAdvanced", "colorSchemes")
  quickColorScheme(showAdvanced, schemes) {
    if (showAdvanced) {
      return null;
    }
    const scheme = schemes.find(c => {
      return c.id !== null;
    });
    return scheme;
  },

  actions: {
    showAdvanced() {
      this.set("advancedOverride", true);
    },

    saveQuickColorScheme() {
      this.set("isSaving", true);
      this.get("quickColorScheme")
        .save()
        .then(() => {
          this.set("isSaving", false);
        });
    },

    shareModal() {
      showModal("user-themes-share-modal", { model: this.get("model") });
    },

    addUploadModal() {
      showModal("user-themes-upload-modal", {
        name: "",
        admin: true,
        templateName: "admin-add-upload"
      });
    },

    createColorScheme() {
      this.set("creatingColorScheme", true);

      const theme_id = this.get("model.id");
      ajax(`/user_themes/${theme_id}/colors`, {
        type: "POST",
        data: {}
      })
        .then(() => {
          this.set("creatingColorScheme", false);
          this.send("refreshThemes");
        })
        .catch(popupAjaxError);
    },

    destroyColorScheme() {
      this.get("colorSchemes")
        .findBy("id", this.get("model.color_scheme_id"))
        .destroy()
        .then(() => {
          this.send("refreshThemes");
        });
    },

    destroy() {
      return bootbox.confirm(
        I18n.t("theme_creator.delete_confirm"),
        I18n.t("no_value"),
        I18n.t("yes_value"),
        result => {
          if (result) {
            const model = this.get("model");
            model.destroyRecord().then(() => {
              this.get("allThemes").removeObject(model);
              this.transitionToRoute("user.themes");
            });
          }
        }
      );
    }
  }
});

import EmberObject, { action } from "@ember/object";
import { alias } from "@ember/object/computed";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { url } from "discourse/lib/computed";
import discourseComputed from "discourse-common/utils/decorators";
import ThemeUploadAddModal from "admin/components/theme-upload-add";
import AdminCustomizeThemesShowController from "admin/controllers/admin-customize-themes-show";
import I18n from "I18n";
import ThemesColors from "discourse/plugins/discourse-theme-creator/discourse/mixins/themes-colors";
import UserThemesShareModal from "../components/modal/user-themes-share-modal";

export default class UserThemesShow extends AdminCustomizeThemesShowController.extend(
  ThemesColors
) {
  @service dialog;
  @service modal;
  @service router;

  parentController = EmberObject.create({ model: { content: [] } });
  @alias("model.id") id;
  @alias("quickColorScheme.colors") colors;

  editRouteName = "user.themes.edit";
  @url("model.id", "/user_themes/%@/export") downloadUrl;
  advancedOverride = false;

  @discourseComputed("model.color_scheme_id")
  colorSchemeEditDisabled(colorSchemeId) {
    return colorSchemeId === null;
  }

  @discourseComputed(
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
  }

  @discourseComputed("quickColorScheme")
  hasQuickColorScheme(scheme) {
    return !!scheme;
  }

  @discourseComputed("showAdvanced", "colorSchemes")
  quickColorScheme(showAdvanced, schemes) {
    if (showAdvanced) {
      return null;
    }
    const scheme = schemes.find((c) => {
      return c.id !== null;
    });
    return scheme;
  }

  @action
  saveMetadata() {
    return this.get("model").saveChanges("remote_theme");
  }

  @action
  showAdvancedAction() {
    this.set("advancedOverride", true);
  }

  @action
  saveQuickColorScheme() {
    this.set("isSaving", true);
    this.get("quickColorScheme")
      .save()
      .then(() => {
        this.set("isSaving", false);
      });
  }

  @action
  shareModal() {
    this.modal.show(UserThemesShareModal, { model: this.model });
  }

  @action
  addUploadModal() {
    this.modal.show(ThemeUploadAddModal, {
      model: {
        themeFields: this.model.theme_fields,
        addUpload: this.addUpload,
        uploadUrl: "/user_themes/upload_asset",
      },
    });
  }

  @action
  createColorScheme() {
    this.set("creatingColorScheme", true);

    const theme_id = this.get("model.id");
    ajax(`/user_themes/${theme_id}/colors`, {
      type: "POST",
      data: {},
    })
      .then(() => {
        this.set("creatingColorScheme", false);
        this.send("refreshThemes");
      })
      .catch(popupAjaxError);
  }

  @action
  destroyColorScheme() {
    this.get("colorSchemes")
      .findBy("id", this.get("model.color_scheme_id"))
      .destroy()
      .then(() => {
        this.send("refreshThemes");
      });
  }

  @action
  destroy() {
    return this.dialog.deleteConfirm({
      message: I18n.t("theme_creator.delete_confirm"),
      didConfirm: () => {
        const model = this.get("model");
        model.destroyRecord().then(() => {
          this.get("allThemes").removeObject(model);
          this.router.transitionTo("user.themes");
        });
      },
    });
  }
}

import EmberObject, { action, computed } from "@ember/object";
import { alias } from "@ember/object/computed";
import { service } from "@ember/service";
import ThemeUploadAddModal from "discourse/admin/components/theme-upload-add";
import AdminCustomizeThemesShowIndexController from "discourse/admin/controllers/admin-customize-themes/show/index";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { url } from "discourse/lib/computed";
import { i18n } from "discourse-i18n";
import UserThemesShareModal from "../../../components/modal/user-themes-share-modal";

export default class UserThemesShow extends AdminCustomizeThemesShowIndexController {
  @service dialog;
  @service modal;
  @service router;

  parentController = EmberObject.create({ model: { content: [] } });
  @alias("model.id") id;
  @alias("quickColorScheme.colors") colors;

  editRouteName = "user.themes.edit";
  @url("model.id", "/user_themes/%@/export") downloadUrl;
  @url("id", "/user_themes/%@/preview") previewUrl;
  advancedOverride = false;

  @computed("model.color_scheme_id")
  get colorSchemeEditDisabled() {
    return this.model?.color_scheme_id === null;
  }

  @computed(
    "advancedOverride",
    "colorSchemes",
    "model.uploads",
    "model.hasEditedFields",
    "model.component"
  )
  get showAdvanced() {
    return (
      this.advancedOverride ||
      this.model?.uploads?.length > 0 ||
      this.colorSchemes.length > 2 ||
      this.model?.hasEditedFields ||
      this.model?.component
    );
  }

  @computed("quickColorScheme")
  get hasQuickColorScheme() {
    return !!this.quickColorScheme;
  }

  @computed("showAdvanced", "colorSchemes")
  get quickColorScheme() {
    if (this.showAdvanced) {
      return null;
    }
    const scheme = this.colorSchemes.find((c) => {
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

  @computed("isSaving")
  get saveButtonText() {
    return this.isSaving ? i18n("saving") : i18n("theme_creator.save");
  }

  @computed("colors.@each.changed")
  get hidePreview() {
    return this.colors && this.colors?.some((color) => color.get("changed"));
  }

  @action
  shareModal(event) {
    event?.preventDefault();
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
      message: i18n("theme_creator.delete_confirm"),
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

import ArrayProxy from "@ember/array/proxy";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DiscourseRoute from "discourse/routes/discourse";
import InstallThemeModal from "admin/components/modal/install-theme";
import ColorSchemeColor from "admin/models/color-scheme-color";
import I18n from "I18n";
import UserThemesEditLocalModal from "../components/modal/user-themes-edit-local-modal";
import UserColorScheme from "../models/user-color-scheme";

export default class UserThemes extends DiscourseRoute {
  @service modal;
  @service router;

  model() {
    return this.store
      .findAll("user-theme", { user_id: this.modelFor("user").id })
      .then((data) => {
        const ColorSchemes = ArrayProxy.extend({});
        const colorSchemes = ColorSchemes.create({
          content: [],
          loading: true,
        });
        data.extras.color_schemes.forEach((colorScheme) => {
          colorSchemes.pushObject(
            UserColorScheme.create({
              id: colorScheme.id,
              name: colorScheme.name,
              is_base: colorScheme.is_base,
              theme_id: colorScheme.theme_id,
              theme_name: colorScheme.theme_name,
              base_scheme_id: colorScheme.base_scheme_id,
              colors: colorScheme.colors.map(function (c) {
                return ColorSchemeColor.create({
                  name: c.name,
                  hex: c.hex,
                  default_hex: c.default_hex,
                });
              }),
            })
          );
        });

        data.set("colorSchemes", colorSchemes);

        return data;
      });
  }

  titleToken() {
    return I18n.t("theme_creator.my_themes");
  }

  @action
  addTheme(theme, afterTransition) {
    const all = this.modelFor("user.themes");
    all.pushObject(theme);
    this.router
      .transitionTo("user.themes.show", theme.get("id"))
      .then(afterTransition);
  }

  @action
  installModal() {
    const adminCustomizeThemesController = this.controllerFor(
      "adminCustomizeThemes"
    );
    this.modal.show(InstallThemeModal, {
      model: {
        keyGenUrl: "/user_themes/generate_key_pair",
        importUrl: "/user_themes/import",
        selection: "create",
        recordType: "user-theme",
        selectedType: adminCustomizeThemesController.currentTab,
        userId: this.modelFor("user").id,
        content: this.currentModel.content,
        installedThemes: adminCustomizeThemesController.installedThemes,
        addTheme: this.addTheme,
        updateSelectedType: (type) =>
          adminCustomizeThemesController.set("currentTab", type),
      },
    });
  }

  @action
  editLocalModal() {
    this.modal.show(UserThemesEditLocalModal);
  }

  @action
  refreshThemes() {
    this.refresh();
  }
}

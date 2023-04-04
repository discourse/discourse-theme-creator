import I18n from "I18n";
import UserColorScheme from "../models/user-color-scheme";
import ColorSchemeColor from "admin/models/color-scheme-color";
import showModal from "discourse/lib/show-modal";
import DiscourseRoute from "discourse/routes/discourse";
import { action } from "@ember/object";
import ArrayProxy from "@ember/array/proxy";

export default class UserThemes extends DiscourseRoute {
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
    this.transitionTo("user.themes.show", theme.get("id")).then(
      afterTransition
    );
  }

  @action
  installModal() {
    showModal("user-themes-install-modal", {
      admin: true,
      templateName: "admin-install-theme",
      model: { user_id: this.modelFor("user").id },
    });
  }

  @action
  editLocalModal() {
    showModal("user-themes-edit-local-modal", { model: { apiKey: null } });
  }

  @action
  refreshThemes() {
    this.refresh();
  }
}

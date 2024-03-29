import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";

function initializeWithApi(api) {
  api.addNavigationBarItem({
    name: "styleguide",
    displayName: I18n.t("theme_creator.styleguide"),
    title: I18n.t("theme_creator.styleguide"),
    href: "/styleguide",
  });
}

export default {
  name: "add-styleguide-button",
  initialize() {
    withPluginApi("0.1", initializeWithApi);
  },
};

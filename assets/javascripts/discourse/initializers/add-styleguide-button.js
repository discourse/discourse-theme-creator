import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";

function initializeWithApi(api) {
  api.addNavigationBarItem({
    name: "styleguide",
    displayName: i18n("theme_creator.styleguide"),
    title: i18n("theme_creator.styleguide"),
    href: "/styleguide",
  });
}

export default {
  name: "add-styleguide-button",
  initialize() {
    withPluginApi("0.1", initializeWithApi);
  },
};

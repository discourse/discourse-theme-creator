import { withPluginApi } from "discourse/lib/plugin-api";

function initializeWithApi(api) {
  api.modifyClass("component:admin-theme-editor", {
    pluginId: "discourse-theme-creator",
    allowAdvanced: true,
  });
}

export default {
  name: "enable-advanced",
  initialize() {
    withPluginApi(initializeWithApi);
  },
};

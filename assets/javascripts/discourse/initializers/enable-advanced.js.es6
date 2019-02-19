import { withPluginApi } from "discourse/lib/plugin-api";

function initializeWithApi(api) {
  api.modifyClass("component:admin-theme-editor", {
    allowAdvanced: true
  });
}

export default {
  name: "enable-advanced",
  initialize() {
    withPluginApi("0.1", initializeWithApi);
  }
};

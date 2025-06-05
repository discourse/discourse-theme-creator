import RouteTemplate from "ember-route-template";
import UserThemesView from "../components/user-themes-view";

export default RouteTemplate(
  <template><UserThemesView @model={{@model}} /></template>
);

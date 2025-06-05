import Component from "@ember/component";
import { classNames, tagName } from "@ember-decorators/component";
import avatar from "discourse/helpers/avatar";

@tagName("span")
@classNames("admin-customize-themes-list-item-outlet", "theme-user-icon")
export default class ThemeUserIcon extends Component {
  <template>{{avatar this.theme.user imageSize="tiny"}}</template>
}

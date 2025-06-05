import Component from "@ember/component";
import { LinkTo } from "@ember/routing";
import { classNames, tagName } from "@ember-decorators/component";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";

@tagName("li")
@classNames("user-main-nav-outlet", "themes")
export default class Themes extends Component {
  static shouldRender(args, context) {
    const current = context.currentUser;
    return current && (current.id === args.model.get("id") || current.staff);
  }

  <template>
    <LinkTo @route="user.themes">
      {{icon "paintbrush"}}
      {{i18n "theme_creator.themes"}}
    </LinkTo>
  </template>
}

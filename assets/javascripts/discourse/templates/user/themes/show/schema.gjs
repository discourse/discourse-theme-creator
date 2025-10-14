import { hash } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import RouteTemplate from "ember-route-template";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";
import UserSchemaThemeSettingEditor from "../../../../components/user-schema-theme-setting-editor";

export default RouteTemplate(
  <template>
    <div class="customize-themes-show-schema__header row">
      <LinkTo
        @route="user.themes.show"
        @model={{@model.theme.id}}
        class="btn-transparent customize-themes-show-schema__back"
      >
        {{icon "arrow-left"}}{{@model.theme.name}}
      </LinkTo>
      <h2>
        {{i18n
          "admin.customize.schema.title"
          (hash name=@model.setting.setting)
        }}
      </h2>
    </div>

    <UserSchemaThemeSettingEditor
      @id={{@model.theme.id}}
      @routeToRedirect="user.themes.show"
      @schema={{@model.setting.objects_schema}}
      @setting={{@model.setting}}
    />
  </template>
);

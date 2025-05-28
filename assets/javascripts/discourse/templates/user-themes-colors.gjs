import { LinkTo } from "@ember/routing";
import RouteTemplate from "ember-route-template";
import DButton from "discourse/components/d-button";
import TextField from "discourse/components/text-field";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";
import ColorSchemeEditor from "../components/color-scheme-editor";

export default RouteTemplate(
  <template>
    <div class="theme-content">
      <h2>
        <TextField @value={{@controller.model.name}} @autofocus="true" />
      </h2>

      <h4>
        ({{i18n "theme_creator.color_scheme_belongs_to"}}
        <LinkTo
          @route="user.themes.show"
          @model={{@controller.model.theme_id}}
          @replace={{true}}
        >
          {{@controller.model.theme_name}}
        </LinkTo>)
      </h4>

      <ColorSchemeEditor @colors={{@controller.model.colors}} />

      <DButton
        @action={{@controller.save}}
        @disabled={{@controller.isSaving}}
        class="btn-primary"
      >
        {{@controller.saveButtonText}}
      </DButton>

      {{#unless @controller.hidePreview}}
        <a
          href={{@controller.previewUrl}}
          title={{i18n "theme_creator.explain_preview"}}
          class="btn"
          target="_blank"
          rel="noopener noreferrer"
        >
          {{icon "desktop"}}
          {{i18n "theme_creator.preview"}}
        </a>
      {{/unless}}
    </div>
  </template>
);

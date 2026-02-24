import { LinkTo } from "@ember/routing";
import DButton from "discourse/components/d-button";
import routeAction from "discourse/helpers/route-action";
import { i18n } from "discourse-i18n";

export default <template>
  <div class="user-theme-creator">
    {{#unless @controller.editingTheme}}
      <div class="user-theme-list">
        <LinkTo @route="user.themes">
          <div class="user-theme-list-heading">
            {{i18n "theme_creator.my_themes"}}
          </div>
        </LinkTo>

        <ul>
          {{#each @controller.model as |theme|}}
            <li>
              <LinkTo
                @route="user.themes.show"
                @model={{theme}}
                @replace={{true}}
              >
                {{theme.name}}
              </LinkTo>
            </li>
          {{/each}}
        </ul>

        <div class="user-create-theme">
          <DButton
            @action={{routeAction "installModal"}}
            @icon="upload"
            @label="theme_creator.install_theme"
            class="btn-primary"
          />
          <DButton
            @action={{routeAction "editLocalModal"}}
            @icon="laptop-code"
            @label="theme_creator.api_key"
          />
        </div>
      </div>
    {{/unless}}

    <div class="user-theme-details {{if @controller.editingTheme 'editing'}}">
      {{outlet}}
    </div>
  </div>
</template>

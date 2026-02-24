import Component from "@glimmer/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import ColorInput from "discourse/admin/components/color-input";
import { i18n } from "discourse-i18n";

export default class ColorSchemeEditor extends Component {
  @action
  revert(color) {
    color.revert();
  }

  @action
  undo(color) {
    color.undo();
  }

  <template>
    {{#if this.colors.length}}
      <table class="table colors">
        <thead>
          <tr>
            <th></th>
            <th class="hex">{{i18n "admin.customize.color"}}</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {{#each this.colors as |c|}}
            <tr
              class="{{if c.changed 'changed'}}{{if c.valid 'valid' 'invalid'}}"
            >
              <td class="name" title={{c.name}}>
                <b>{{c.translatedName}}</b>
                <br />
                <span class="description">{{c.description}}</span>
              </td>
              <td class="hex">
                <ColorInput
                  @hexValue={{c.hex}}
                  @brightnessValue={{c.brightness}}
                  @valid={{c.valid}}
                />
              </td>
              <td class="actions">
                <button
                  {{on "click" (fn this.revert c)}}
                  type="button"
                  class="btn revert {{unless c.savedIsOverriden 'invisible'}}"
                >
                  {{i18n "revert"}}
                </button>
                <button
                  {{on "click" (fn this.undo c)}}
                  type="button"
                  class="btn undo {{unless c.changed 'invisible'}}"
                >
                  {{i18n "undo"}}
                </button>
              </td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    {{else}}
      <p>{{i18n "search.no_results"}}</p>
    {{/if}}
  </template>
}

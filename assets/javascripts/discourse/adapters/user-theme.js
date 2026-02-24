import { Result } from "discourse/adapters/rest";
import ThemeAdapter from "discourse/admin/adapters/theme";
import { ajax } from "discourse/lib/ajax";

export default class UserThemeAdapter extends ThemeAdapter {
  typeField = "theme";

  basePath() {
    return "/";
  }

  // Override update method
  // Possible PR to core to make typeField configurable?
  update(store, type, id, attrs) {
    const data = {};
    const typeField = this.get("typeField");
    data[typeField] = attrs;

    return ajax(
      this.pathFor(store, type, id),
      this.getPayload("PUT", data)
    ).then(function (json) {
      return new Result(json[typeField], json);
    });
  }

  createRecord(store, type, attrs) {
    const data = {};
    const typeField = this.get("typeField");
    data[typeField] = attrs;
    return ajax(this.pathFor(store, type), this.getPayload("POST", data)).then(
      function (json) {
        return new Result(json[typeField], json);
      }
    );
  }

  afterFindAll(results) {
    results = super.afterFindAll(results);
    results.forEach((theme) => {
      if (!theme.get("remote_theme")) {
        theme.set("remote_theme", {});
      }
    });
    return results;
  }
}

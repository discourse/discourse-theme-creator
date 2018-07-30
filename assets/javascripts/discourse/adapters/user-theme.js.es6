import Theme from "admin/adapters/theme";
import { ajax } from "discourse/lib/ajax";
import { Result } from "discourse/adapters/rest";

export default Theme.extend({
  basePath() {
    return "/";
  },

  typeField: "theme",

  // Override update method
  // Possible PR to core to make typeField configurable?
  update(store, type, id, attrs) {
    const data = {};
    const typeField = this.get("typeField");
    data[typeField] = attrs;

    return ajax(
      this.pathFor(store, type, id),
      this.getPayload("PUT", data)
    ).then(function(json) {
      return new Result(json[typeField], json);
    });
  },

  createRecord(store, type, attrs) {
    const data = {};
    const typeField = this.get("typeField");
    data[typeField] = attrs;
    return ajax(this.pathFor(store, type), this.getPayload("POST", data)).then(
      function(json) {
        return new Result(json[typeField], json);
      }
    );
  }
});

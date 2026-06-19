import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";

export default class UserOrcidPublicationsRoute extends DiscourseRoute {
  model() {
    const user = this.modelFor("user");
    return ajax(`/u/${user.username}/orcid-publications`).then((data) => {
      return { user, publications: data.publications };
    });
  }
}
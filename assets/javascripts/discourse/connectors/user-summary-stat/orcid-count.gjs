import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import i18n from "discourse-common/helpers/i18n";
import { LinkTo } from "@ember/routing";

export default class OrcidCount extends Component {
  @tracked pubCount = 0;
  @tracked isLoading = true;

  constructor() {
    super(...arguments);
    this.fetchCount();
  }

  get hasOrcid() {
    return !!this.args.outletArgs.model.user_fields?.["17"];
  }

  async fetchCount() {
    if (!this.hasOrcid) return;

    const username = this.args.outletArgs.model.username;
    try {
      const data = await ajax(`/u/${username}/orcid-publications`);
      this.pubCount = data.publications?.length || 0;
    } catch (e) {
      this.pubCount = 0;
    } finally {
      this.isLoading = false;
    }
  }

  <template>
    {{#if this.hasOrcid}}
      <li class="linked-stat orcid-stat">
        <LinkTo @route="user.orcidPublications" @model={{@outletArgs.model}}>
          <span class="value">
            {{#if this.isLoading}}
              <div class="spinner-small"></div>
            {{else}}
              {{this.pubCount}}
            {{/if}}
          </span>
          <span class="label">{{i18n "discourse_orcid_publications.tab_title"}}</span>
        </LinkTo>
      </li>
    {{/if}}
  </template>
}
import Component from "@glimmer/component";
// DÜZELTİLEN SATIR:
import i18n from "discourse-common/helpers/i18n";
import icon from "discourse-common/helpers/d-icon";

export default class OrcidPublicationsList extends Component {
  <template>
    <div class="orcid-publications-wrapper">
      <h2 class="orcid-publications-title">{{i18n "discourse_orcid_publications.publications_header"}}</h2>

      {{#if @publications.length}}
        <ul class="orcid-publications-list">
          {{#each @publications as |pub|}}
            <li class="publication-item">
              <div class="publication-title">
                {{#if pub.url}}
                  <a href={{pub.url}} target="_blank" rel="noopener noreferrer">{{pub.title}}</a>
                {{else}}
                  {{pub.title}}
                {{/if}}
              </div>
              <div class="publication-meta">
                {{#if pub.journal}}
                  <span class="journal">{{icon "file-alt"}} {{pub.journal}}</span>
                {{/if}}
                {{#if pub.year}}
                  <span class="year">{{icon "calendar-alt"}} {{pub.year}}</span>
                {{/if}}
              </div>
            </li>
          {{/each}}
        </ul>
      {{else}}
        <div class="alert alert-info">
          {{i18n "discourse_orcid_publications.no_publications"}}
        </div>
      {{/if}}
    </div>
  </template>
}
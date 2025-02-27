<script lang="js">
let doctypes = [];
import("@/../../config/doctypes.yml").then(function(data) {
  const keys = Object.keys(data).filter(k => parseInt(k).toString() === k);
  const values = keys.map(k => data[k]);
  return doctypes = values;
});

export default {
  props: {
    model: Object,
    preview: Object,
    remove: {
      default: null,
      type: Function
    }
  },

  data() {
    return {editing: false};
  },

  computed: {
    doctype() {
      return doctypes.find(dt => (new RegExp(dt.regex)).test(this.preview.url)) || {name: 'other'};
    },

    icon() {
      if (this.doctype) {
        return 'mdi-'+this.doctype.icon;
      } else {
        return 'mdi-link-variant';
      }
    },

    iconColor() { return this.doctype.icon; },

    hostname() {
      return new URL(this.preview.url).host;
    }
  }
};
</script>
<template lang="pug">
div
  template(v-if="editing")
    v-card.link-preview.mt-3(outlined style="position: relative")
      .link-preview__image(v-if="preview.image" :style="{'background-image': 'url('+preview.image+')', 'background-size': (preview.fit || 'contain'), 'background-position': (preview.align || 'center')}")
      v-btn.link-preview__btn(color="primary" icon outlined
            :title="$t('common.action.done')"
            style="right: 8px"
            @click="editing = false")
        v-icon mdi-check
      v-card-title
        v-text-field(filled v-model="preview.title")
      v-card-subtitle
        v-textarea(filled v-model="preview.description")

  template(v-else)
    v-card.link-preview.link-preview-link.mt-3(outlined style="position: relative")
      template(v-if="remove")
        v-btn.link-preview__btn(color="primary"
              outlined
              style="right: 8px"
              icon
              @click="remove(preview.url)"
              :title="$t('common.action.remove')")
          v-icon mdi-close
        v-btn.link-preview__btn(color="primary"
              style="right: 48px"
              icon
              outlined
              @click="editing = true"
              :title="$t('common.action.edit')")
          v-icon mdi-pencil

        template(v-if="preview.image")
          v-btn.link-preview__btn(@click="preview.fit = (preview.fit == 'cover' ? 'contain' : 'cover')"
                color="primary" icon outlined
                style="right: 88px"
                :title="$t('common.action.zoom')")
            v-icon(v-if="preview.fit == 'contain'") mdi-magnify-plus-outline
            v-icon(v-else) mdi-magnify-minus-outline
          v-btn.link-preview__btn(v-if="preview.fit == 'cover'"
                @click="preview.align = (preview.align == 'top' ? 'center' : 'top')"
                color="primary" icon outlined
                style="right: 128px"
                :title="$t('common.action.align')")
            v-icon(v-if="preview.align == 'top'") mdi-format-vertical-align-center
            v-icon(v-else) mdi-format-vertical-align-top

      a.link-preview-link(:href="preview.url" target="_blank" rel="nofollow ugc noreferrer noopener")
        div.ml-4
        .link-preview__image(v-if="preview.image" :style="{'background-image': 'url('+preview.image+')', 'background-size': (preview.fit || 'contain'), 'background-position': (preview.align || 'center')}")
        v-card-title.text--secondary
          v-icon.mr-1 mdi-open-in-new
          | {{preview.title}}
        v-card-subtitle
          span(v-if="doctype.name != 'other'" v-t="'doctypes.'+doctype.name")
          span.link-preview__hostname(v-else v-html="preview.hostname")
        v-card-text.text--secondary(v-if="preview.description") {{preview.description}}
</template>

<style lang="sass">
.link-preview
  overflow-wrap: break-word
  word-wrap: break-word
  word-break: break-word
//   opacity: 70%
//
// .link-preview-link:hover
//   opacity: 100%

.link-preview__image
  height: 160px
  overflow: none
  background-position: center
  // max-width: 512px
  // margin: 0 auto
.link-preview__btn
  top: 8px
  position: absolute
</style>

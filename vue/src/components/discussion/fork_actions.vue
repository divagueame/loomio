<script lang="js">
import Records      from '@/shared/services/records';
import openModal      from '@/shared/helpers/open_modal';
export default {
  props: {
    discussion: Object
  },
  methods: {
    openMoveCommentsModal() {
      openModal({
        component: 'MoveCommentsModal',
        props: {
          discussion: this.discussion
        }
      });
    }
  },
  computed: {
    styles() {
      const { bar, top } = this.$vuetify.application;
      return{
        display: 'flex',
        position: 'sticky',
        top: `${bar + top}px`,
        zIndex: 1
      };
    }
  }
};
</script>

<template lang='pug'>
v-banner.discussion-fork-actions(single-line sticky :elevation="4" v-if='discussion.forkedEventIds.length' icon="mdi-call-split" color="primary" :style="styles")
  span(v-t="'discussion_fork_actions.helptext'")
  template(v-slot:actions)
    v-btn(color="primary" @click="openMoveCommentsModal()" v-t="'discussion_fork_actions.move'")
    v-btn(icon @click='discussion.forkedEventIds = []')
      v-icon mdi-close
</template>

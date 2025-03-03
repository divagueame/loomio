<script lang="js">
import ThreadService from '@/shared/services/thread_service';
import AbilityService from '@/shared/services/ability_service';
import { pick, some } from 'lodash-es';

export default {
  props: {
    thread: Object,

    groupPage: {
      type: Boolean,
      default: false
    },

    showGroupName: {
      type: Boolean,
      default: true
    }
  },

  computed: {
    dockActions() {
      return pick(ThreadService.actions(this.thread, this), ['dismiss_thread']);
    },

    menuActions() {
      const actions = this.groupPage ?
        this.$vuetify.breakpoint.smAndDown ?
          ['dismiss_thread','pin_thread', 'unpin_thread', 'edit_thread', 'move_thread', 'close_thread', 'reopen_thread', 'discard_thread']
        :
          ['pin_thread', 'unpin_thread', 'edit_thread', 'move_thread', 'close_thread', 'reopen_thread', 'discard_thread']
      :
        this.$vuetify.breakpoint.smAndDown ?
          ['dismiss_thread', 'close_thread', 'reopen_thread']
        :
          ['close_thread', 'reopen_thread'];
      return pick(ThreadService.actions(this.thread, this), actions);
    },

    canPerformAny() {
      return some(this.menuActions, action => action.canPerform());
    }
  }
};

</script>

<template lang="pug">
v-list-item.thread-preview.thread-preview__link(
  :class="{'thread-preview--unread-border': thread.isUnread()}"
  :to='urlFor(thread)'
)
  v-list-item-avatar
    user-avatar(:user='thread.author()', :size='40' no-link)
  v-list-item-content
    v-list-item-title(style="align-items: center")
      span(v-if='thread.pinnedAt', :title="$t('context_panel.thread_status.pinned')")
        v-icon(small) mdi-pin-outline
      span.thread-preview__title(:class="{'thread-preview--unread': thread.isUnread() }") {{thread.title}}
      v-chip.ml-1(x-small label outlined color="warning" v-if='thread.closedAt' v-t="'common.privacy.closed'")
      tags-display.ml-1(:tags="thread.tags" :group="thread.group()" smaller)
    v-list-item-subtitle
      span.thread-preview__group-name(v-if="showGroupName") {{ thread.group().name }}
      mid-dot(v-if="showGroupName")
      span.thread-preview__items-count(v-t="{path: 'thread_preview.replies_count', args: {count: thread.itemsCount}}")
      space
      span.thread-preview__unread-count(v-if='thread.hasUnreadActivity()' v-t="{path: 'thread_preview.unread_count', args: {count: thread.unreadItemsCount()}}")
      mid-dot
      active-time-ago(:date="thread.lastActivityAt")
  v-list-item-action(v-if='$vuetify.breakpoint.mdAndUp')
    action-dock(:actions="dockActions")
  v-list-item-action(v-if='canPerformAny')
    action-menu(:actions="menuActions" icon)
</template>

<style lang="sass">
.thread-preview
  .v-list-item__avatar
    overflow: visible

.v-list-item__action:last-of-type:not(:only-child), .v-list-item__icon:last-of-type:not(:only-child)
  margin-left: 0

.thread-preview__status-icon
  padding: 4px 8px
.thread-preview__pin
  width: 32px
  font-size: 20px
  text-align: center
.thread-preview--unread
  font-weight: 500
.thread-preview
  border-left: 2px solid transparent
.thread-preview--unread-border
  border-color: var(--v-accent-lighten1)
// .thread-preview__position-icon-container
//   width: 23px
//   height: 23px
//   position: absolute
//   left: 15px
//   top: 43px
//   background-color: white
//   border-radius: 100%
//   box-shadow: 0 2px 1px rgba(0,0,0,.15)
.thread-preview__position-icon
  background-repeat: no-repeat
  height: 21px
  margin: 1px 0 0 1px
  width: 21px
.thread-preview__undecided-icon
  font-size: 14px
  line-height: 24px
  text-align: center

</style>

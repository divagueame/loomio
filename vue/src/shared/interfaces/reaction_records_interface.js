import BaseRecordsInterface from '@/shared/record_store/base_records_interface';
import ReactionModel        from '@/shared/models/reaction_model';
import { debounce } from 'lodash-es';

export default class ReactionRecordsInterface extends BaseRecordsInterface {
  constructor(recordStore) {
    super(recordStore);
    this.model = ReactionModel;
    this.baseConstructor(recordStore);
  }
}

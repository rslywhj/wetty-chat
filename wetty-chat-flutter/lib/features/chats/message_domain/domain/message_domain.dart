import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'message_domain_store.dart';

export 'message_domain_models.dart';
export 'message_domain_store.dart';

final messageDomainStoreProvider = Provider<MessageDomainStore>((ref) {
  return MessageDomainStore();
});

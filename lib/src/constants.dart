// Character pools.
// ignore_for_file: public_member_api_docs, constant_identifier_names,
// ignore_for_file: non_constant_identifier_names

const LOWER_CHAR_POOL = 'abcdefghijklmnopqrstuvwxyz';
const UPPER_CHAR_POOL = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const NUMBER_CHAR_POOL = '0123456789';
const SPECIAL_CHAR_POOL = '-._~+/';

/// The default character pool that is used
/// when generating an API key.
const DEFAULT_CHARACTER_POOL = '$LOWER_CHAR_POOL'
    '$UPPER_CHAR_POOL'
    '$NUMBER_CHAR_POOL'
    '$SPECIAL_CHAR_POOL';

/// Base62 character pool.
const BASE62_CHAR_POOL = '$NUMBER_CHAR_POOL'
    '$LOWER_CHAR_POOL'
    '$UPPER_CHAR_POOL';

/// The default minimum length for an API key.
const DEFAULT_MIN_LENGTH = 16;

/// The default maximum length for an API key.
const DEFAULT_MAX_LENGTH = 32;

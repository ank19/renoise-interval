--   _______ _     _ __   _ _____ __   _  ______ _______
--      |    |     | | \  |   |   | \  | |  ____ |______
--      |    |_____| |  \_| __|__ |  \_| |_____| ______|
--

TUNING = {
    -- Pure intervals
    { {  1,   1},
      { 16,   5},
      {  9,   8},
      {  6,   5},
      {  5,   4},
      {  4,   3},
      { 45,  32},
      {  3,   2},
      {  8,   5},
      {  5,   3},
      { 16,   9},
      { 15,   8},
      {  2,   1} },
    -- Just tuning
    { {  1,   1},
      { 16,   5},
      {  9,   8},
      {  6,   5},
      {  5,   4},
      {  4,   3},
      {  7,   5},
      {  3,   2},
      {  8,   5},
      {  5,   3},
      {  9,   5},
      { 15,   8},
      {  2,   1} },
    -- Equal temperament
    -- The same fractions are used as just tuning, as, of course, the irrational numbers of the equal temperament cannot
    -- be represented as whole number fractions. Just tuning is used as a approximation. Pls. also note that there is a
    -- special rule in the interval_properties() method for calculating cents, as these ratios cannot be used, of course.
    { {  1,   1},
      { 16,   5},
      {  9,   8},
      {  6,   5},
      {  5,   4},
      {  4,   3},
      {  7,   5},
      {  3,   2},
      {  8,   5},
      {  5,   3},
      {  9,   5},
      { 15,   8},
      {  2,   1} },
    -- Pythagorean
    { {  1,   1},
      {256, 243},
      {  9,   8},
      { 32,  27},
      { 81,  64},
      {  4,   3},
      {729, 512},
      {  3,   2},
      {128,  81},
      { 27,  16},
      { 16,   9},
      {253, 128},
      {  2,   1} },
    -- Pythagorean*
    { {  1,   1},
      {256, 243},
      {  9,   8},
      { 32,  27},
      { 81,  64},
      {  4,   3},
      {729, 512},
      {  3,   2},
      {128,  81},
      { 27,  16},
      { 16,   9},
      {253, 128},
      {  2,   1} },
    -- Kirnberger III
    { {  1,   1},
      { 25,  24},
      {  9,   8},
      {  6,   5},
      {  5,   4},
      {  4,   3},
      { 45,  32},
      {  3,   2},
      { 25,  16},
      {  5,   3},
      { 16,   9},
      { 15,   8},
      {  2,   1} },
    -- Rational tuning
    { {  1,   1},
      { 16,  15},
      {  9,   8},
      {  6,   5},
      {  5,   4},
      {  4,   3},
      {  7,   5},
      {  3,   2},
      {  8,   5},
      {  5,   3},
      {  9,   5},
      { 15,   8},
      {  2,   1} } }

--   _______  _____          _____   ______ _______
--   |       |     | |      |     | |_____/ |______
--   |_____  |_____| |_____ |_____| |    \_ ______|
--

COLOR_HEADER_1 = {0x3A, 0x3A, 0x3A}
COLOR_HEADER_2 = {0x50, 0x50, 0x50}

COLOR_DISSONANCE_X = {0x00, 0x0F, 0x00}
COLOR_DISSONANCE_1 = {0x20, 0x5F, 0x20}
COLOR_DISSONANCE_2 = {0x20, 0x3F, 0x20}
COLOR_DISSONANCE_3 = {0x3F, 0x20, 0x20}
COLOR_DISSONANCE_4 = {0x5F, 0x20, 0x20}

COLOR_IS_NOTE = {0x40, 0x40, 0x40}
COLOR_NO_NOTE = {0xA0, 0xA0, 0xA0}

DISSONANCE_COLORS = {COLOR_DISSONANCE_1, COLOR_DISSONANCE_2, COLOR_DISSONANCE_3, COLOR_DISSONANCE_4}

COLOR_DEFAULT = {0x90, 0x90, 0x90}
COLOR_BLACK   = {0x00, 0x00, 0x00}

COLOR_STATUS_WARNING = {0xB0, 0x40, 0x00}

--   _______ _____ ______ _______ _______
--   |______   |    ____/ |______ |______
--   ______| __|__ /_____ |______ ______|
--

HEADER_HEIGHT = 20

--   _____ ______  _______
--     |   |     \ |______
--   __|__ |_____/ ______|
--

ID_HEADER_CHORD_ACTUAL           = "header_chord_actual"
ID_HEADER_CHORD_LINGER           = "header_chord_linger"
ID_SETTINGS                      = "settings"
ID_SETTINGS_RECALCULATION        = "settings_recalculation"
ID_SETTINGS_INTERVAL             = "settings_interval"
ID_SETTINGS_TUNING               = "settings_tuning"
ID_SETTINGS_DISSONANCE_THRESHOLD = "settings_dissonance_threshold"
ID_SETTINGS_HEARING_THRESHOLD    = "settings_hearing_threshold"
ID_SETTINGS_VOLUME_REDUCTION     = "settings_volume_reduction"
ID_SETTINGS_SEARCH_ROWS          = "settings_search_rows"
ID_SETTINGS_MATRIX_SIZE          = "settings_matrix_size"
ID_SETTINGS_DEBUG                = "settings_debug"
ID_ELEMENT                       = "element"
ID_STATUS_BAR                    = "status_bar"
ID_COUNTERPOINT_BAR              = "counterpoint_bar"

--   _______ _______ _______ _______ _     _ _______
--   |______    |    |_____|    |    |     | |______
--   ______|    |    |     |    |    |_____| ______|
--

STATUS_OK                      = "ok"
STATUS_LINES_OMITTED           = "omitted"
COUNTERPOINT_PATTERN_VIOLATION = "pattern_violation"
COUNTERPOINT_OK                = "ok"

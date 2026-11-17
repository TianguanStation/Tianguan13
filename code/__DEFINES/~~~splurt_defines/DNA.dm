///Upstream edits
//Sizecode
#undef BODY_SIZE_MAX
#undef BODY_SIZE_MIN

#ifdef BODY_SIZE_MAX_OVERRIDE
	#define BODY_SIZE_MAX BODY_SIZE_MAX_OVERRIDE
#else
	#define BODY_SIZE_MAX 2.0
#endif

#ifdef BODY_SIZE_MIN_OVERRIDE
	#define BODY_SIZE_MIN BODY_SIZE_MIN_OVERRIDE
#else
	#define BODY_SIZE_MIN 0.1
#endif

///arachnid organ slots
#define ORGAN_SLOT_EXTERNAL_MANDIBLES "mandibles"
#define ORGAN_SLOT_EXTERNAL_SPINNERET "spinneret"
#define ORGAN_SLOT_EXTERNAL_SPIDER_LEGS "spider_legs"

/* -*- Mode: C++ -*-  */
/* This is public-domain Mersenne Twister code,
 * attributed to Michael Brundage.  Thanks!
 * http://www.qbrundage.com/michaelb/pubs/essays/random_number_generation.html
 */
class MTRandom {
 public:
  static const uint32_t TEST_SEED1 = 5489UL;

  static const int MT_LEN = 624;
  static const int MT_IA = 397;
  static const uint32_t UPPER_MASK = 0x80000000;
  static const uint32_t LOWER_MASK = 0x7FFFFFFF;
  static const uint32_t MATRIX_A = 0x9908B0DF;

  MTRandom() {
    Init(TEST_SEED1);
  }

  MTRandom(uint32_t seed) {
    Init(seed);
  }

  uint32_t Rand32 () {
    uint32_t y;
    static unsigned long mag01[2] = { 
      0 , MATRIX_A
    };

    if (mt_index_ >= MT_LEN) {
      int kk;

      for (kk = 0; kk < MT_LEN - MT_IA; kk++) {
	y = (mt_buffer_[kk] & UPPER_MASK) | (mt_buffer_[kk + 1] & LOWER_MASK);
	mt_buffer_[kk] = mt_buffer_[kk + MT_IA] ^ (y >> 1) ^ mag01[y & 0x1UL];
      }
      for (;kk < MT_LEN - 1; kk++) {
	y = (mt_buffer_[kk] & UPPER_MASK) | (mt_buffer_[kk + 1] & LOWER_MASK);
	mt_buffer_[kk] = mt_buffer_[kk + (MT_IA - MT_LEN)] ^ (y >> 1) ^ mag01[y & 0x1UL];
      }
      y = (mt_buffer_[MT_LEN - 1] & UPPER_MASK) | (mt_buffer_[0] & LOWER_MASK);
      mt_buffer_[MT_LEN - 1] = mt_buffer_[MT_IA - 1] ^ (y >> 1) ^ mag01[y & 0x1UL];

      mt_index_ = 0;
    }
  
    y = mt_buffer_[mt_index_++];

    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    return y;
  }

  uint32_t ExpRand32(uint32_t mean) {
    double mean_d = mean;
    double erand  = log (1.0 / (Rand32() / (double)UINT32_MAX));
    uint32_t x = (uint32_t) (mean_d * erand + 0.5);
    return x;
  }

  uint64_t Rand64() {
    return ((uint64_t)Rand32() << 32) | Rand32();
  }

  uint64_t ExpRand64(uint64_t mean) {
    double mean_d = mean;
    double erand  = log (1.0 / (Rand64() / (double)UINT32_MAX));
    uint64_t x = (uint64_t) (mean_d * erand + 0.5);
    return x;
  }

  template <typename T>
  T Rand() {
    switch (sizeof(T)) {
    case sizeof(uint32_t):
      return Rand32();
    case sizeof(uint64_t):
      return Rand64();
    default:
      cerr << "Invalid sizeof T" << endl;
      abort();
    }
  }

  template <typename T>
  T ExpRand(T mean) {
    switch (sizeof(T)) {
    case sizeof(uint32_t):
      return ExpRand32(mean);
    case sizeof(uint64_t):
      return ExpRand64(mean);
    default:
      cerr << "Invalid sizeof T" << endl;
      abort();
    }
  }

 private:
  void Init(uint32_t seed) {
    mt_buffer_[0] = seed;
    mt_index_ = MT_LEN;
    for (int i = 1; i < MT_LEN; i++) {
      /* See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier. */
      /* In the previous versions, MSBs of the seed affect   */
      /* only MSBs of the array mt[].                        */
      /* 2002/01/09 modified by Makoto Matsumoto             */
      mt_buffer_[i] = 
	(1812433253UL * (mt_buffer_[i-1] ^ (mt_buffer_[i-1] >> 30)) + i);
    }
  }

  int mt_index_;
  uint32_t mt_buffer_[MT_LEN];
};

class MTRandom8 {
public:
  MTRandom8(MTRandom *rand)
    : rand_(rand) {
  }

  uint8_t Rand8() {
    uint32_t r = rand_->Rand32();

    // TODO: make this use a single byte at a time?
    return (r & 0xff) ^ (r >> 7) ^ (r >> 15) ^ (r >> 21);
  }

private:
  MTRandom *rand_;
};

if (M >= 0 && N >= 0)
  for (int c0 = -4; c0 <= 3 * M + N; c0 += 1) {
    if (c0 >= 3 * M) {
      S2(M, -3 * M + c0);
    } else if (3 * M >= c0 + 4 && (c0 + 1) % 3 == 0) {
      S1((c0 + 4) / 3, 0);
    }
    for (int c1 = max(-3 * M + c0 + 3, (c0 + 6) % 3); c1 <= min(N - 1, c0); c1 += 3) {
      S2((c0 - c1) / 3, c1);
      S1(((c0 - c1) / 3) + 1, c1 + 1);
    }
    if (3 * M + N >= c0 + 3 && c0 >= N && (N - c0) % 3 == 0) {
      S2((-N + c0) / 3, N);
    } else if (N >= c0 + 4 && c0 >= -3) {
      S1(0, c0 + 4);
    }
    for (int c1 = max(-3 * M + c0, (c0 + 6) % 3); c1 <= min(N, c0); c1 += 3)
      S3((c0 - c1) / 3, c1);
  }

flowchart TD
    A([Start / Preload Trigger])


    %% Awareness App State
    A --> B{App Foreground?}
    B -- No --> Z1([STOP])
    B -- Yes --> C{Internet Available?}
    C -- No --> Z1
    C -- Yes --> D{Cooldown Active?}
    D -- Yes --> Z1
    D -- No --> E{Retry >= MaxRetry?}


    %% Retry limit
    E -- Yes --> Z1
    E -- No --> F{Ad is Loading?}


    %% Loading check
    F -- Yes --> G[Wait 20-30s]
    G --> A


    %% Cache check
    F -- No --> H{Has Cached Ad?}
    H -- Yes --> I[Wait 10s]
    I --> A


    %% Request
    H -- No --> J[Request New Ad]
    J --> K{Ad Filled?}


    %% Success
    K -- Yes --> L[Cache Ad<br/>Reset Retry<br/>Clear Loading]
    L --> Z2([READY TO SHOW])


    %% Failure
    K -- No --> M[Retry++<br/>Clear Loading]
    M --> N[Backoff Delay<br/>10s -> 20s -> 40s -> cap]
    N --> A


1. Vấn đề gốc mà sơ đồ muốn giải quyết
Khi preload banner / native, app luôn rơi vào 3 trạng thái xấu:

Load quá sớm → tốn request, fill thấp

Load quá dồn dập khi fail → spam network, dễ bị hạn chế fill

Load khi không thể show (background, không mạng, cooldown) → request vô nghĩa

👉 Sơ đồ không phải để “vẽ cho đẹp”, mà để đảm bảo mỗi lần request đều có lý do chính đáng.

2. Ý tưởng lớn của sơ đồ (1 câu)
Chỉ request ads khi có khả năng được hiển thị, và nếu fail thì chờ lâu dần lên.

Toàn bộ sơ đồ chỉ xoay quanh 2 nguyên tắc này.

3. Ý tưởng được chia thành 4 lớp logic
LỚP 1 – “CÓ ĐÁNG LOAD KHÔNG?”
( Awareness App State )

Trước khi nghĩ đến ads, app tự hỏi:

❓ Nếu bây giờ load ad, có khả năng user nhìn thấy nó không?

Nếu KHÔNG, thì không làm gì cả.

Các câu hỏi cụ thể:
App có đang mở không? (foreground)

Có internet không?

User có vừa xem ad xong không? (cooldown)

Screen hiện tại / sắp tới có hiển thị ad không?

👉 Fail bất kỳ câu nào → STOP, không delay, không retry.

⛔ Đây là chỗ 90% app làm sai: vẫn load dù không thể show.

LỚP 2 – “CÓ CẦN LOAD NGAY KHÔNG?”
( Cache & Loading )

Giả sử đáng load rồi, app hỏi tiếp:

❓ Đang load ad rồi à?
Có → đừng load thêm → đợi một chút

❓ Đã có ad sẵn trong bộ nhớ chưa?
Có → dùng cái đó đã → chưa cần load mới

👉 Ý nghĩa:

Mỗi thời điểm chỉ 1 request

Không bao giờ load thừa

LỚP 3 – “LOAD THÌ LOAD”
( Request )

Chỉ khi:

đáng load

chưa load

chưa có ad

→ mới thực sự gửi request ads

Đây là điểm duy nhất trong sơ đồ có Request Ad.

LỚP 4 – “FAIL THÌ XỬ LÝ THẾ NÀO?”
( Backoff )

❌ Nếu fail:
App không làm thế này:

“Fail → load lại ngay”

Mà làm thế này:

“Fail → chờ lâu hơn lần trước → rồi mới thử lại”

Ví dụ:

Fail 1 → chờ 10s

Fail 2 → chờ 20s

Fail 3 → chờ 40s

👉 Vì:

ad network cần thời gian

load dồn dập làm fill rate tệ hơn

4. Vòng lặp của sơ đồ (rất quan trọng)
Sơ đồ không phải vòng lặp vô hạn.

Nó chỉ lặp khi:

app còn mở

còn internet

chưa vượt retry

vẫn chưa có ad

Nếu một điều kiện không còn đúng → vòng lặp dừng ngay.

5. Ví dụ thực tế (đọc cái này là hiểu)
Tình huống 1 – App vừa mở
App foreground ✔

Có mạng ✔

Chưa có ad ✔

→ Load ad

Tình huống 2 – Load fail
Fail lần 1 → chờ 10s

Trong 10s đó user thoát app ❌

→ KHÔNG load lại
(vì awareness layer chặn)

Tình huống 3 – User vừa xem native
Cooldown 90s

Trong 90s đó có trigger preload

→ STOP, không request

Tình huống 4 – Có ad sẵn
Cache còn ad

Có trigger preload mới

→ Không load thêm, chờ dùng ad hiện tại

6. Vì sao sơ đồ này “đáng dùng”?
Nó giúp bạn:

Không spam ads

Không vi phạm policy

Fill rate ổn định hơn

Dễ debug (biết vì sao không load)

Dễ mở rộng cho inter / rewarded

7. Nếu tóm gọn thành 1 pseudo-rule
Không chắc là user sẽ thấy ad → đừng load
Fail rồi → đừng vội load lại
Có ad rồi → đừng load thêm

---

# RELOAD ADS LOGIC

## Flowchart

```mermaid
flowchart TD
    A([Start<br/>Re-load]) --> B{checkVisibility()<br/>App đang mở?<br/>Ads đang show?}

    B -- No --> Z[Stop / Wait next trigger]

    B -- Yes --> C{Check cache<br/>Có ad sẵn?}

    %% ===== CASE: CÓ CACHE =====
    C -- Yes --> D[Destroy / Dispose<br/>ads cũ<br/>Giải phóng bộ nhớ<br/>Show ad mới vào vị trí cũ]
    D --> E([Start Pre-load])

    %% ===== CASE: KHÔNG CÓ CACHE =====
    C -- No --> F[Request ad mới]

    F --> G{Có ad trả về?}

    %% Load thành công
    G -- Yes --> H[Destroy / Dispose<br/>ads cũ<br/>Giải phóng bộ nhớ<br/>Show ad mới]

    %% Load thất bại
    G -- No --> I[Delay 10s - 15s]
    I --> A

    %% ===== REMOTE CONFIG TRIGGER =====
    RC[Remote Config<br/>sau n(s)] --> A

```

Ghi chú quan trọng:

checkVisibility là gate bắt buộc → nếu app background hoặc ads không show thì KHÔNG reload

Cache ưu tiên tuyệt đối

Pre-load chỉ chạy sau khi show ad từ cache

Retry có delay, không loop liên tục

Remote Config có thể kích hoạt reload lại từ đầu

tận dụng field autoLoad trong NativeAdWidget để có thể tối ưu nhất chất lượng logic code

## 1. Vấn đề gốc mà sơ đồ reload giải quyết

Khi reload banner/native ad, app thường gặp các vấn đề:

- **Race condition**: Nhiều reload trigger liên tục → duplicate requests → crash hoặc ad overlap
- **Memory leak**: Old ad không được destroy đúng cách trước khi show ad mới
- **View hierarchy issues**: Banner cũ chưa detach khỏi view tree khi banner mới được add
- **Wasted requests**: Reload khi widget không visible → tốn request vô ích

👉 Sơ đồ này đảm bảo: **mỗi lần reload đều atomic, safe, và có ý nghĩa**

## 2. Ý tưởng lớn (1 câu)

**Chỉ reload khi visible, ưu tiên cache, và đảm bảo destroy cũ trước khi show mới.**

## 3. Chia thành 4 lớp logic

### LỚP 1 – RACE CONDITION GUARD
(Lock/Mutex)

```dart
bool _isReloading = false;

Future<void> reload() async {
  // Guard: chỉ 1 reload tại 1 thời điểm
  if (_isReloading) {
    _log('⚠️ Reload already in progress, skipping');
    return;
  }
  _isReloading = true;

  try {
    await _performReload();
  } finally {
    _isReloading = false;
  }
}
```

👉 Ý nghĩa:
- Ngăn multiple reload chạy đồng thời
- Tránh race condition và duplicate requests
- State luôn nhất quán

### LỚP 2 – VISIBILITY CHECK
(Awareness)

Trước khi reload, kiểm tra:
- Widget có đang visible trên screen không?
- App có đang foreground không?

```dart
bool get _canReload {
  if (!_isWidgetVisible) {
    _log('❌ Cannot reload: widget not visible');
    return false;
  }

  if (!lifecycleManager.isAppInForeground) {
    _log('❌ Cannot reload: app in background');
    return false;
  }

  return true;
}
```

👉 Nếu không visible → STOP ngay, không reload

### LỚP 3 – CACHE STRATEGY
(Optimization)

```dart
Future<void> _performReload() async {
  if (!_canReload) return;

  if (_hasCachedAd) {
    // Path A: Có cache → swap nhanh
    await _destroyCurrentAd();
    await _showCachedAd();
    _preloadNextAd(); // Fire and forget
  } else {
    // Path B: Không cache → request mới
    await _requestAndShowNewAd();
  }
}
```

👉 Ưu tiên cache để instant display, đồng thời preload ad tiếp theo

### LỚP 4 – DESTROY TIMING
(Critical - Tránh memory leak & view issues)

```dart
Future<void> _destroyCurrentAd() async {
  if (_currentAd == null) return;

  // 1. Detach khỏi view tree trước
  _adContainer.removeView(_currentAdView);

  // 2. Đợi frame tiếp theo để ensure detach hoàn tất
  await WidgetsBinding.instance.endOfFrame;

  // 3. Destroy ad object
  await _currentAd!.destroy();
  _currentAd = null;

  _log('🗑️ Old ad destroyed and detached');
}
```

👉 **QUAN TRỌNG**: Phải detach khỏi view TRƯỚC khi destroy

### LỚP 5 – BACKOFF RETRY
(Failure handling)

```dart
int _reloadRetryCount = 0;
static const _maxReloadRetries = 4;
static const _reloadBackoffDelays = [
  Duration(seconds: 10),
  Duration(seconds: 20),
  Duration(seconds: 40),
  Duration(seconds: 60), // cap
];

void _onReloadFailed() {
  _reloadRetryCount++;

  if (_reloadRetryCount >= _maxReloadRetries) {
    _log('🛑 Max reload retries reached, stopping');
    return;
  }

  // Exponential backoff with cap
  final delayIndex = (_reloadRetryCount - 1).clamp(0, _reloadBackoffDelays.length - 1);
  final delay = _reloadBackoffDelays[delayIndex];

  _log('⏰ Scheduling reload retry in ${delay.inSeconds}s');

  _reloadTimer?.cancel();
  _reloadTimer = Timer(delay, () {
    reload(); // Re-trigger reload
  });
}

void _onReloadSuccess() {
  _reloadRetryCount = 0;
  _log('✅ Reload successful, retry counter reset');
}
```

## 4. Full Implementation Pseudocode

```dart
class ReloadScheduler {
  bool _isReloading = false;
  int _reloadRetryCount = 0;
  Timer? _reloadTimer;
  NativeAd? _cachedAd;
  NativeAd? _currentAd;

  static const _maxRetries = 4;
  static const _backoffDelays = [
    Duration(seconds: 10),
    Duration(seconds: 20),
    Duration(seconds: 40),
    Duration(seconds: 60),
  ];

  /// Main entry point
  Future<void> reload() async {
    // LAYER 1: Lock guard
    if (_isReloading) {
      _log('⚠️ Reload in progress, skipping');
      return;
    }
    _isReloading = true;

    try {
      // LAYER 2: Visibility check
      if (!_canReload) {
        return;
      }

      // LAYER 3: Cache strategy
      if (_cachedAd != null) {
        await _reloadFromCache();
      } else {
        await _reloadFromNetwork();
      }
    } finally {
      _isReloading = false;
    }
  }

  bool get _canReload {
    if (!_isWidgetVisible) return false;
    if (!_isAppInForeground) return false;
    return true;
  }

  /// Path A: Reload from cache (fast path)
  Future<void> _reloadFromCache() async {
    _log('📦 Reloading from cache');

    // Step 1: Destroy old
    await _destroyCurrentAd();

    // Step 2: Show cached
    _currentAd = _cachedAd;
    _cachedAd = null;
    await _showCurrentAd();

    // Step 3: Preload next (fire and forget)
    _preloadNextAd();

    _onReloadSuccess();
  }

  /// Path B: Reload from network (slow path)
  Future<void> _reloadFromNetwork() async {
    _log('🌐 Reloading from network');

    final newAd = await _requestNewAd();

    if (newAd != null) {
      // Success: destroy old → show new
      await _destroyCurrentAd();
      _currentAd = newAd;
      await _showCurrentAd();
      _onReloadSuccess();
    } else {
      // Failure: schedule retry
      _onReloadFailed();
    }
  }

  /// LAYER 4: Safe destroy with proper detach
  Future<void> _destroyCurrentAd() async {
    if (_currentAd == null) return;

    // Detach from view first
    _detachFromView();

    // Wait for frame to complete
    await WidgetsBinding.instance.endOfFrame;

    // Then destroy
    await _currentAd!.destroy();
    _currentAd = null;
  }

  void _onReloadFailed() {
    _reloadRetryCount++;

    if (_reloadRetryCount >= _maxRetries) {
      _log('🛑 Max retries reached');
      return;
    }

    final delayIndex = (_reloadRetryCount - 1).clamp(0, _backoffDelays.length - 1);
    final delay = _backoffDelays[delayIndex];

    _reloadTimer?.cancel();
    _reloadTimer = Timer(delay, reload);
  }

  void _onReloadSuccess() {
    _reloadRetryCount = 0;
  }

  void dispose() {
    _reloadTimer?.cancel();
    _cachedAd?.destroy();
    _currentAd?.destroy();
  }
}
```

## 5. Điểm quan trọng cần lưu ý

### 5.1 Race Condition Prevention
```dart
// ❌ SAI - Không có lock
Future<void> reload() async {
  await _destroyOld();
  await _loadNew();
  await _show();
}

// ✅ ĐÚNG - Có lock
Future<void> reload() async {
  if (_isReloading) return;
  _isReloading = true;
  try {
    await _destroyOld();
    await _loadNew();
    await _show();
  } finally {
    _isReloading = false;
  }
}
```

### 5.2 Destroy Timing (Critical!)
```dart
// ❌ SAI - Destroy trước khi detach
_currentAd.destroy();
_container.removeView(_adView); // Crash!

// ✅ ĐÚNG - Detach trước, destroy sau
_container.removeView(_adView);
await Future.delayed(Duration(milliseconds: 16)); // 1 frame
_currentAd.destroy();
```

### 5.3 Preload Failure Handling
```dart
void _preloadNextAd() {
  _requestNewAd().then((ad) {
    if (ad != null) {
      _cachedAd = ad;
      _log('✅ Next ad preloaded');
    } else {
      _cachedAd = null; // Clear để vòng sau request lại
      _log('⚠️ Preload failed, cache cleared');
    }
  });
}
```

### 5.4 Exponential Backoff with Cap
```dart
// Delay sequence: 10s → 20s → 40s → 60s (cap) → 60s → 60s...
final delays = [10, 20, 40, 60];
final delayIndex = min(retryCount - 1, delays.length - 1);
final delay = delays[delayIndex];
```

## 6. So sánh Preload vs Reload Logic

| Aspect | Preload | Reload |
|--------|---------|--------|
| Trigger | App start, background | User action, auto-refresh |
| Visibility check | Foreground only | Widget visible + Foreground |
| Cache behavior | Fill cache | Use cache → preload next |
| Destroy old | N/A | Required before show new |
| Lock needed | No (single request) | Yes (prevent overlap) |
| Backoff delays | 10→20→40s | 10→20→40→60s (cap) |
| Max retries | 3 | 4 |

## 7. Tình huống thực tế

### Tình huống 1 – Reload với cache có sẵn
```
User tap reload
├─ isReloading = false ✔
├─ Widget visible ✔
├─ App foreground ✔
├─ Cache has ad ✔
│   ├─ Destroy old ad
│   ├─ Show cached ad (instant!)
│   └─ Preload next ad (background)
└─ Done
```

### Tình huống 2 – Reload không có cache
```
User tap reload
├─ isReloading = false ✔
├─ Widget visible ✔
├─ Cache empty
│   └─ Request new ad
│       ├─ Success
│       │   ├─ Destroy old ad
│       │   └─ Show new ad
│       └─ Fail
│           └─ Schedule retry 10s later
└─ Done
```

### Tình huống 3 – Reload spam (liên tục)
```
Reload #1 trigger → isReloading = true, processing...
Reload #2 trigger → BLOCKED (isReloading = true)
Reload #3 trigger → BLOCKED
Reload #1 done → isReloading = false
Reload #4 trigger → Accepted, processing...
```

### Tình huống 4 – Reload khi widget ẩn
```
User navigate away (widget hidden)
Auto-refresh timer triggers reload
├─ Widget visible = false ❌
└─ STOP - không reload
```

## 8. Pseudo-rule tóm tắt

```
Đang reload → đừng reload thêm
Không visible → đừng reload
Có cache → dùng cache, preload tiếp
Fail → chờ lâu dần lên (10s → 20s → 40s → 60s)
Destroy cũ → đợi detach xong → mới show mới
```

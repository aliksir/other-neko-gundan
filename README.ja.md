# other-neko-gundan

**猫軍団フレームワークから抽出した、CLI非依存の品質ルール集。**

[猫軍団（neko-gundan）](https://github.com/aliksir/neko-gundan)はClaude Code用のマルチエージェント
オーケストレーションシステムです。しかし、その品質プロトコルの多くはClaude固有のAPIに依存しません
— コード品質をどう考えるかを記述したMarkdownドキュメントです。

このパッケージは、それらのポータブルなルールを抽出し、任意のAI CLIで使えるようにしたものです。

---

## 対応CLI

| CLI | アダプタファイル | 仕組み |
|-----|---------------|--------|
| [Codex CLI](https://github.com/openai/codex) | `AGENTS.md` | プロジェクトルートの `AGENTS.md` を自動読み込み |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `GEMINI.md` | プロジェクトルートの `GEMINI.md` を自動読み込み |
| [Aider](https://aider.chat/) | `.aider.conf.yml` + `conventions.md` | セッション毎にconventionsファイルを読み込み |
| その他のCLI | 手動セットアップ | 必要なルールをコピーしてシステムプロンプトから参照 |

---

## クイックスタート

```bash
# リポジトリをクローン（またはgit submoduleとして使用）
git clone https://github.com/aliksir/other-neko-gundan.git

# インストーラを実行（プロジェクトディレクトリを指定）
bash other-neko-gundan/scripts/install.sh ./your-project
```

インストーラの動作:
1. インストール済みのCLIを自動検出（`codex`, `gemini`, `aider`）
2. 対応するアダプタファイルをプロジェクトルートにコピー
3. `rules/` と `templates/` をプロジェクトにコピー
4. 既存ファイルはスキップ（上書き前に確認）

---

## 同梱内容

### rules/

コア品質プロトコル — タスク開始前に読んでください。

| ファイル | 内容 |
|---------|------|
| `review-protocol.md` | 実装者≠レビュアー、レビュー3サイクル上限、レビュアーは読み取り専用 |
| `safety-tiers.md` | 破壊操作の制御（Tier 1: 絶対禁止 / Tier 2: 要確認） |
| `completion-gates.md` | 証拠ベースの完了基準 — 検証なしにゲート通過なし |
| `reflexion.md` | 構造化された失敗振り返り（何が / なぜ / 次の具体的アクション） |
| `linter-protection.md` | linter設定を弱めてエラーを消すな — コードを直せ |
| `process-weight.md` | Light / Standard / Strict の3段階、リスク増大時のエスカレーション |
| `checklist-export.md` | タスクチェックリストの外部ファイル管理 |
| `quality-metrics.md` | タスク毎のメトリクス蓄積とトレンド分析 |
| `audit-trail.md` | 意思決定と変更のトレーサビリティ記録 |
| `faceted-prompting.md` | 関心の分離によるプロンプト構造設計 |
| `isv.md` | Intent State Vector — タスクの意図と結果の多次元追跡 |
| `jit-tests.md` | git diffから生成する使い捨てテスト |
| `spec-driven-review.md` | 「動くか」だけでなく「仕様に合っているか」を検証 |
| `whiteboard.md` | エージェント間（またはセッション間）の共有知識ファイル |
| `raw-log.md` | 全エージェントアクションの完全な監査証跡（1行1アクション形式） |
| `review-output.md` | レビュー結果（simplify、レビュアー）をファイルに永続化 |
| `fides.md` | データ信頼レベル（HIGH / MEDIUM / LOW）と昇格手順 |
| `race-prevention.md` | 並列作業時のファイル競合防止 |

### templates/

すぐに使えるテンプレート集。

| ファイル | 用途 |
|---------|------|
| `plan.md` | タスク計画書（スコープ、手順、成功基準） |
| `result-report.md` | 完了報告書（証拠とメトリクス付き） |
| `checklist.md` | 作業+QAチェックリスト |
| `whiteboard.md` | セッション横断の共有知識 |
| `audit-trail/traceability.md` | 要件→実装のトレーサビリティ |
| `audit-trail/approvals.md` | 承認記録 |
| `audit-trail/changes.md` | 変更管理台帳 |
| `audit-trail/audit-report.md` | 監査サマリーレポート |

### adapters/

CLI別の設定ファイル。

```
adapters/
  codex/   AGENTS.md          — Codex CLI用（プロジェクトルートにコピー）
  gemini/  GEMINI.md          — Gemini CLI用（プロジェクトルートにコピー）
  aider/   .aider.conf.yml    — Aider用（プロジェクトルートにコピー）
           conventions.md     — Aiderが毎セッション読み込む規約ファイル
```

---

## 手動セットアップ

インストーラを使わない場合、手動でファイルをコピー:

```bash
# 1. ルールとテンプレートをコピー
cp -r other-neko-gundan/rules/     ./rules/
cp -r other-neko-gundan/templates/ ./templates/

# 2. 使用するCLIのアダプタをコピー
cp other-neko-gundan/adapters/codex/AGENTS.md  ./AGENTS.md   # Codex
cp other-neko-gundan/adapters/gemini/GEMINI.md ./GEMINI.md   # Gemini
cp other-neko-gundan/adapters/aider/.aider.conf.yml ./       # Aider
cp other-neko-gundan/adapters/aider/conventions.md  ./
```

その他のCLIでは、システムプロンプトからルールを参照:

```
Before any task, read these files:
- rules/review-protocol.md
- rules/completion-gates.md
- rules/safety-tiers.md
```

---

## 猫軍団との関係

[猫軍団（neko-gundan）](https://github.com/aliksir/neko-gundan)はClaude Code用のフルフレームワークです。
マルチエージェント制御機能（`TeamCreate`、`SendMessage`、`TaskGet`等）はClaude Code専用です。

**other-neko-gundan** はそのポータブルなサブセット:

| 機能 | neko-gundan | other-neko-gundan |
|------|-----------|-------------------|
| 品質ルール（レビュー、ゲート、安全） | あり | あり |
| テンプレート（計画書、チェックリスト、報告書） | あり | あり |
| CLIアダプタ（Codex、Gemini、Aider） | なし | あり |
| マルチエージェント制御 | あり | なし |
| Heartbeat / Pollingプロトコル | あり | なし |
| 容量エスカレーション | あり | なし |
| Ensemble Judge | あり | なし |

Claude Codeを使っているなら → [neko-gundan](https://github.com/aliksir/neko-gundan)
それ以外のCLIなら → このパッケージ

---

## ライセンス

MIT — [LICENSE](LICENSE) を参照

// ets/pages/DetailPage.ets
import { NotebookManager, NoteItem } from '../model/NoteData';
import { Constants } from '../utils/Constants';
import router from '@ohos.router';

@Entry
@Component
struct DetailPage {
  @State note: NoteItem | null = null;

  // 第9行修改
  private notebookManager: NotebookManager = NotebookManager.getInstance();
  private noteId: string = '';

  aboutToAppear(): void {
    // 使用router.getParams()获取参数
    const params = router.getParams() as Record<string, string>;
    this.noteId = params['id'] || '';

    if (this.noteId) {
      const foundNote = this.notebookManager.getNoteById(this.noteId);
      if (foundNote) {
        this.note = foundNote;
      }
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Button('< 返回')
          .fontColor(Constants.COLORS.TEXT_PRIMARY)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('笔记详情')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('编辑')
          .fontColor(Constants.COLORS.PRIMARY)
          .backgroundColor(Color.Transparent)
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            if (this.note) {
              router.pushUrl({
                url: 'pages/EditNotePage',
                params: { id: this.note.id }
              });
            }
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 10, bottom: 10 })
      .backgroundColor(Constants.COLORS.CARD_BG)

      if (this.note) {
        Scroll() {
          Column() {
            // 笔记标题
            Text(this.note.title)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.COLORS.TEXT_PRIMARY)
              .margin({ top: 20, bottom: 15 })
              .width('100%')
              .padding({ left: 20, right: 20 })

            // 笔记信息
            Row() {
              Column() {
                Text('分类')
                  .fontSize(12)
                  .fontColor(Constants.COLORS.TEXT_SECONDARY)
                Text(this.note.category)
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.getCategoryColor(this.note.category))
              }
              .layoutWeight(1)

              Column() {
                Text('创建时间')
                  .fontSize(12)
                  .fontColor(Constants.COLORS.TEXT_SECONDARY)
                Text(this.note.createTime)
                  .fontSize(14)
                  .fontColor(Constants.COLORS.TEXT_PRIMARY)
              }
              .layoutWeight(1)

              Column() {
                Text('更新时间')
                  .fontSize(12)
                  .fontColor(Constants.COLORS.TEXT_SECONDARY)
                Text(this.note.updateTime)
                  .fontSize(14)
                  .fontColor(Constants.COLORS.TEXT_PRIMARY)
              }
              .layoutWeight(1)
            }
            .width('100%')
            .padding({ left: 20, right: 20, bottom: 20 })

            // 分割线
            Divider()
              .strokeWidth(1)
              .color(Constants.COLORS.BORDER)
              .margin({ left: 20, right: 20 })

            // 笔记内容
            Text(this.note.content)
              .fontSize(16)
              .fontColor(Constants.COLORS.TEXT_PRIMARY)
              .lineHeight(28)
              .margin({ top: 20, bottom: 40 })
              .width('100%')
              .padding({ left: 20, right: 20 })
          }
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        Column() {
          // 使用内置图标或文本代替不存在的图片资源
          Text('⚠️')
            .fontSize(60)
            .margin({ bottom: 20 })

          Text('未找到该笔记')
            .fontSize(16)
            .fontColor(Constants.COLORS.TEXT_SECONDARY)

          Button('返回', { type: ButtonType.Capsule })
            .margin({ top: 20 })
            .backgroundColor(Constants.COLORS.PRIMARY)
            .fontColor(Color.White)
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLORS.BACKGROUND)
  }

  private getCategoryColor(category: string): ResourceColor {
    const color = Constants.CATEGORY_COLORS.get(category);
    if (color) {
      // 将十六进制颜色字符串转换为ResourceColor
      return color as ResourceColor;
    }
    return Constants.COLORS.PRIMARY as ResourceColor;
  }
}
// ets/pages/Index.ets
import { NotebookManager, NoteItem } from '../model/NoteData';
import { Constants } from '../utils/Constants';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  @State notes: NoteItem[] = [];
  @State searchText: string = '';
  @State selectedCategory: string = '全部';
  @State isSearching: boolean = false;
  @State showStats: boolean = false;

  private notebookManager: NotebookManager = NotebookManager.getInstance();
  private categories: string[] = [];
  private categoryStats: Map<string, number> = new Map();

  aboutToAppear(): void {
    this.loadData();
  }

  loadData(): void {
    this.categories = this.notebookManager.getAllCategories();
    if (this.isSearching && this.searchText) {
      this.notes = this.notebookManager.searchNotes(this.searchText);
    } else if (this.selectedCategory) {
      this.notes = this.notebookManager.getNotesByCategory(this.selectedCategory);
    } else {
      this.notes = this.notebookManager.getAllNotes();
    }
    this.categoryStats = this.notebookManager.getCategoryStats();
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text(Constants.APP_NAME)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLORS.PRIMARY)

        Blank()

        Text(`共${this.notebookManager.getTotalCount()}条`)
          .fontSize(14)
          .fontColor(Constants.COLORS.TEXT_SECONDARY)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 10, bottom: 10 })
      .backgroundColor(Constants.COLORS.CARD_BG)

      // 搜索栏
      Row() {
        TextInput({ placeholder: '搜索笔记标题或内容...', text: this.searchText })
          .width('80%')
          .height(40)
          .backgroundColor(Constants.COLORS.BACKGROUND)
          .borderRadius(20)
          .padding({ left: 15, right: 15 })
          .onChange((value: string) => {
            this.searchText = value;
            if (value) {
              this.isSearching = true;
            } else {
              this.isSearching = false;
            }
            this.loadData();
          })

        Button('搜索', { type: ButtonType.Capsule, stateEffect: true })
          .width(60)
          .height(40)
          .backgroundColor(Constants.COLORS.PRIMARY)
          .fontColor(Color.White)
          .onClick(() => {
            this.isSearching = true;
            this.loadData();
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 10, bottom: 10 })

      // 分类筛选
      Scroll() {
        Row() {
          ForEach(this.categories, (category: string) => {
            Button(category, { type: ButtonType.Capsule })
              .margin(5)
              .backgroundColor(this.selectedCategory === category ?
                Constants.COLORS.PRIMARY : Constants.COLORS.BACKGROUND)
              .fontColor(this.selectedCategory === category ?
                Color.White : Constants.COLORS.TEXT_PRIMARY)
              .onClick(() => {
                this.selectedCategory = category;
                this.isSearching = false;
                this.searchText = '';
                this.loadData();
              })
          })
        }
        .padding(10)
      }
      .height(60)

      // 统计信息
      Row() {
        Text('统计')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)

        Blank()

        // 使用文本图标代替图片资源
        Text(this.showStats ? '▲' : '▼')
          .fontSize(20)
          .fontColor(Constants.COLORS.PRIMARY)
          .onClick(() => {
            this.showStats = !this.showStats;
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 10 })

      if (this.showStats) {
        // 使用Scroll包裹统计信息
        Scroll() {
          Row() {
            ForEach(Array.from(this.categoryStats.entries()), (item: [string, number]) => {
              Column() {
                Text(item[0])
                  .fontSize(12)
                  .fontColor(Constants.COLORS.TEXT_SECONDARY)
                Text(item[1].toString())
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Constants.COLORS.PRIMARY)
              }
              .padding({ left: 15, right: 15 })
              .margin(5)
              .backgroundColor(Constants.COLORS.BACKGROUND)
              .borderRadius(8)
            })
          }
          .width('100%')
          .padding({ left: 15, right: 15, bottom: 10 })
          .justifyContent(FlexAlign.Start)
        }
        .height(80)
      }

      // 笔记列表
      if (this.notes.length > 0) {
        List({ space: 10 }) {
          ForEach(this.notes, (note: NoteItem, index: number) => {
            ListItem() {
              this.noteCard(note)
            }
          }, (note: NoteItem) => note.id)
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 15, right: 15 })
      } else {
        Column() {
          // 使用文本图标代替图片资源
          Text('📝')
            .fontSize(80)
            .margin({ bottom: 20 })

          Text(this.isSearching ? '未找到相关笔记' : '暂无笔记')
            .fontSize(16)
            .fontColor(Constants.COLORS.TEXT_SECONDARY)

          if (!this.isSearching) {
            Button('添加第一条笔记', { type: ButtonType.Capsule })
              .margin({ top: 20 })
              .backgroundColor(Constants.COLORS.PRIMARY)
              .fontColor(Color.White)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/AddNotePage'
                })
              })
          }
        }
        .width('100%')
        .height('60%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }

      // 底部添加按钮
      Row() {
        Button('+ 新建笔记', { type: ButtonType.Capsule })
          .width('90%')
          .height(50)
          .backgroundColor(Constants.COLORS.PRIMARY)
          .fontColor(Color.White)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/AddNotePage'
            })
          })
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Constants.COLORS.CARD_BG)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLORS.BACKGROUND)
  }

  @Builder
  noteCard(note: NoteItem) {
    Column() {
      Row() {
        Text(note.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.COLORS.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Blank()

        Text(note.category)
          .fontSize(12)
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .backgroundColor(this.getCategoryColor(note.category))
          .fontColor(Color.White)
          .borderRadius(10)
      }
      .width('100%')
      .margin({ bottom: 8 })

      Text(note.content)
        .fontSize(14)
        .fontColor(Constants.COLORS.TEXT_SECONDARY)
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 8 })

      Row() {
        Text(note.updateTime)
          .fontSize(12)
          .fontColor(Constants.COLORS.TEXT_SECONDARY)

        Blank()

        Row() {
          Button('编辑')
            .width(60)
            .height(30)
            .backgroundColor(Constants.COLORS.BACKGROUND)
            .fontColor(Constants.COLORS.PRIMARY)
            .fontSize(12)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/EditNotePage',
                params: { id: note.id }
              })
            })

          Button('删除')
            .width(60)
            .height(30)
            .backgroundColor(Constants.COLORS.BACKGROUND)
            .fontColor(Constants.COLORS.ERROR)
            .fontSize(12)
            .margin({ left: 10 })
            .onClick(() => {
              this.deleteNote(note.id);
            })
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding(15)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 5, color: '#1A000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/DetailPage',
        params: { id: note.id }
      })
    })
  }

  private deleteNote(id: string): void {
    // 在ArkUI中，可以使用自定义弹窗或系统提示
    // 这里使用一个简单的确认方式
    // 或者使用promptAction.showDialog
    promptAction.showDialog({
      title: '确认删除',
      message: '确定要删除这条笔记吗？删除后无法恢复。',
      buttons: [
        {
          text: '取消',
          color: Constants.COLORS.TEXT_PRIMARY
        },
        {
          text: '删除',
          color: Constants.COLORS.ERROR
        }
      ]
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 1) { // 用户点击了"删除"按钮
        if (this.notebookManager.deleteNote(id)) {
          this.loadData();
          promptAction.showToast({
            message: '删除成功',
            duration: 2000
          });
        }
      }
    }).catch((err: Error) => {
      console.error('Show dialog error: ' + JSON.stringify(err));
    });
  }

  private getCategoryColor(category: string): ResourceColor {
    const color = Constants.CATEGORY_COLORS.get(category);
    if (color) {
      return color as ResourceColor;
    }
    return Constants.COLORS.PRIMARY as ResourceColor;
  }
  // 添加页面显示时的回调
  onPageShow(): void {
    console.info('Index页面显示，刷新数据');
    this.loadData();
  }


}
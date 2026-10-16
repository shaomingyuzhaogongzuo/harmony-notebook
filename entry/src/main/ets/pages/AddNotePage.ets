// ets/pages/AddNotePage.ets
import { NotebookManager } from '../model/NoteData';
import { Constants } from '../utils/Constants';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct AddNotePage {
  @State title: string = '';
  @State content: string = '';
  @State selectedCategory: string = '默认';
  @State newCategory: string = '';
  @State showAddCategory: boolean = false;

  private notebookManager: NotebookManager = NotebookManager.getInstance();
  private categories: string[] = [];

  aboutToAppear(): void {
    this.categories = this.notebookManager.getAllCategories().filter(cat => cat !== '全部');
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Button('取消')
          .fontColor(Constants.COLORS.TEXT_PRIMARY)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            router.back();
          })

        Text('新建笔记')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('保存')
          .fontColor(Constants.COLORS.PRIMARY)
          .backgroundColor(Color.Transparent)
          .fontWeight(FontWeight.Bold)
          .enabled(this.title.trim().length > 0 && this.content.trim().length > 0)
          .onClick(() => {
            this.saveNote();
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15, top: 10, bottom: 10 })
      .backgroundColor(Constants.COLORS.CARD_BG)

      Scroll() {
        Column() {
          // 标题输入
          Text('标题')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 15, bottom: 8, left: 15 })
            .alignSelf(ItemAlign.Start)

          TextInput({ placeholder: '请输入标题', text: this.title })
            .width('100%')
            .height(50)
            .backgroundColor(Color.White)
            .padding(15)
            .onChange((value: string) => {
              this.title = value;
            })

          // 分类选择
          Text('分类')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 15, bottom: 8, left: 15 })
            .alignSelf(ItemAlign.Start)

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
                  })
              })

              Button('+', { type: ButtonType.Circle })
                .width(40)
                .height(40)
                .backgroundColor(Constants.COLORS.BACKGROUND)
                .fontColor(Constants.COLORS.PRIMARY)
                .margin(5)
                .onClick(() => {
                  this.showAddCategory = !this.showAddCategory;
                })
            }
            .padding(10)
          }
          .height(60)

          if (this.showAddCategory) {
            Row() {
              TextInput({ placeholder: '新分类名称', text: this.newCategory })
                .layoutWeight(1)
                .height(40)
                .backgroundColor(Color.White)
                .padding({ left: 15, right: 15 })
                .margin({ right: 10 })
                .borderRadius(20)
                .onChange((value: string) => {
                  this.newCategory = value;
                })

              Button('添加', { type: ButtonType.Capsule })
                .width(60)
                .height(40)
                .backgroundColor(Constants.COLORS.PRIMARY)
                .fontColor(Color.White)
                .onClick(() => {
                  if (this.newCategory.trim()) {
                    this.notebookManager.addCategory(this.newCategory.trim());
                    this.categories = this.notebookManager.getAllCategories().filter(cat => cat !== '全部');
                    this.selectedCategory = this.newCategory.trim();
                    this.newCategory = '';
                    this.showAddCategory = false;
                  }
                })
            }
            .padding({ left: 15, right: 15, bottom: 10 })
          }

          // 内容输入
          Text('内容')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 15, bottom: 8, left: 15 })
            .alignSelf(ItemAlign.Start)

          TextArea({ placeholder: '请输入笔记内容...', text: this.content })
            .width('100%')
            .height(300)
            .backgroundColor(Color.White)
            .padding(15)
            .onChange((value: string) => {
              this.content = value;
            })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLORS.BACKGROUND)
  }

  private saveNote(): void {
    console.info('开始保存笔记...');
    console.info(`标题: ${this.title}, 内容: ${this.content}, 分类: ${this.selectedCategory}`);

    const success = this.notebookManager.addNote(this.title, this.content, this.selectedCategory);

    if (success) {
      promptAction.showToast({
        message: '保存成功',
        duration: 1500
      });

      // 清空表单
      this.title = '';
      this.content = '';
      this.selectedCategory = '默认';

      // 延迟返回
      setTimeout(() => {
        try {
          router.back();
        } catch (error) {
          console.error('返回页面失败: ' + error);
        }
      }, 800);
    } else {
      promptAction.showToast({
        message: '保存失败，请重试',
        duration: 2000
      });
    }
  }
}
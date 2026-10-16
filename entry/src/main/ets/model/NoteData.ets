// ets/model/NoteData.ets
export class NoteItem {
  id: string;
  title: string;
  content: string;
  category: string;
  createTime: string;
  updateTime: string;

  constructor(title: string, content: string, category: string = '默认') {
    this.id = Date.now().toString() + Math.random().toString(36).substr(2);
    this.title = title;
    this.content = content;
    this.category = category;
    this.createTime = this.formatDate(new Date());
    this.updateTime = this.createTime;
  }

  private formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');
    return `${year}-${month}-${day} ${hour}:${minute}`;
  }

  updateInfo(title?: string, content?: string, category?: string): void {
    if (title) this.title = title;
    if (content) this.content = content;
    if (category) this.category = category;
    this.updateTime = this.formatDate(new Date());
  }
}

export class NotebookManager {
  private notes: NoteItem[] = [];
  private categories: string[] = ['默认', '工作', '学习', '生活', '想法'];

  // 单例实例
  private static instance: NotebookManager;

  // 私有构造函数
  private constructor() {
    // 添加一些示例数据
    this.notes.push(new NoteItem('欢迎使用记事本', '这是一个简单的记事本应用，支持添加、编辑、删除和搜索笔记。', '默认'));
    this.notes.push(new NoteItem('会议记录', '下午2点与客户开会讨论项目进展。\n- 项目进度\n- 遇到的问题\n- 下一步计划', '工作'));
    this.notes.push(new NoteItem('学习计划', '本周学习计划：\n1. 学习ArkTS语法\n2. 完成记事本项目\n3. 复习HarmonyOS开发', '学习'));
    console.info('NotebookManager 初始化完成，初始笔记数:', this.notes.length);
  }

  // 获取单例实例
  public static getInstance(): NotebookManager {
    if (!NotebookManager.instance) {
      NotebookManager.instance = new NotebookManager();
    }
    return NotebookManager.instance;
  }

  // 获取所有笔记
  getAllNotes(): NoteItem[] {
    return this.notes.slice().reverse(); // 按时间倒序
  }

  // 添加新笔记
  addNote(title: string, content: string, category: string): boolean {
    try {
      const newNote = new NoteItem(title, content, category);
      this.notes.push(newNote);
      console.info(`添加笔记成功: ${title}, 当前笔记数: ${this.notes.length}`);
      return true;
    } catch (error) {
      console.error(`添加笔记失败: ${error}`);
      return false;
    }
  }

  // 更新笔记
  updateNote(id: string, title: string, content: string, category: string): boolean {
    const index = this.notes.findIndex(note => note.id === id);
    if (index !== -1) {
      this.notes[index].updateInfo(title, content, category);
      console.info(`更新笔记成功: ${title}, ID: ${id}`);
      return true;
    }
    console.warn(`未找到要更新的笔记, ID: ${id}`);
    return false;
  }

  // 删除笔记
  deleteNote(id: string): boolean {
    const index = this.notes.findIndex(note => note.id === id);
    if (index !== -1) {
      this.notes.splice(index, 1);
      console.info(`删除笔记成功, ID: ${id}, 剩余笔记数: ${this.notes.length}`);
      return true;
    }
    console.warn(`未找到要删除的笔记, ID: ${id}`);
    return false;
  }

  // 获取笔记详情
  getNoteById(id: string): NoteItem | undefined {
    const note = this.notes.find(note => note.id === id);
    console.info(`查找笔记 ID: ${id}, 结果: ${note ? '找到' : '未找到'}`);
    return note;
  }

  // 搜索笔记
  searchNotes(keyword: string): NoteItem[] {
    if (!keyword.trim()) {
      return this.getAllNotes();
    }
    const lowerKeyword = keyword.toLowerCase();
    return this.notes.filter(note =>
    note.title.toLowerCase().includes(lowerKeyword) ||
    note.content.toLowerCase().includes(lowerKeyword)
    ).reverse();
  }

  // 按分类筛选
  getNotesByCategory(category: string): NoteItem[] {
    if (category === '全部') {
      return this.getAllNotes();
    }
    return this.notes.filter(note => note.category === category).reverse();
  }

  // 获取所有分类
  getAllCategories(): string[] {
    return ['全部', ...this.categories];
  }

  // 添加新分类
  addCategory(category: string): void {
    if (!this.categories.includes(category) && category.trim()) {
      this.categories.push(category.trim());
      console.info(`添加分类成功: ${category}`);
    }
  }

  // 获取笔记总数
  getTotalCount(): number {
    return this.notes.length;
  }

  // 获取分类统计
  getCategoryStats(): Map<string, number> {
    const stats = new Map<string, number>();
    this.notes.forEach(note => {
      const count = stats.get(note.category) || 0;
      stats.set(note.category, count + 1);
    });
    return stats;
  }
}
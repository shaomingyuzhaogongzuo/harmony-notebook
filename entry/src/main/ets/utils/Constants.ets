// ets/utils/Constants.ets

// 定义颜色类型
interface ColorConfig {
  PRIMARY: string;
  SUCCESS: string;
  WARNING: string;
  ERROR: string;
  BACKGROUND: string;
  CARD_BG: string;
  TEXT_PRIMARY: string;
  TEXT_SECONDARY: string;
  BORDER: string;
}

export class Constants {
  static readonly APP_NAME: string = '个人记事本';
  static readonly APP_VERSION: string = '1.0.0';

  // 颜色常量 - 使用明确的类型
  static readonly COLORS: ColorConfig = {
    PRIMARY: '#007DFF',
    SUCCESS: '#00C853',
    WARNING: '#FF9500',
    ERROR: '#FF3B30',
    BACKGROUND: '#F1F3F5',
    CARD_BG: '#FFFFFF',
    TEXT_PRIMARY: '#000000',
    TEXT_SECONDARY: '#666666',
    BORDER: '#E5E5E5'
  };

  // 分类颜色映射
  static readonly CATEGORY_COLORS: Map<string, string> = new Map([
    ['默认', '#007DFF'],
    ['工作', '#FF9500'],
    ['学习', '#00C853'],
    ['生活', '#FF3B30'],
    ['想法', '#AF52DE']
  ]);
}
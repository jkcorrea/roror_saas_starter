export type Styles = {
  'test3': string;
  'test': string;
  'test2': string;
}

export type ClassNames = keyof Styles;

declare const styles: Styles;

export default styles;

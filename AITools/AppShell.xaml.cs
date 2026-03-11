namespace AITools
{
    public partial class AppShell : Shell
    {
        public AppShell()
        {
            InitializeComponent();

            // 确保路由已注册
            Routing.RegisterRoute("modelsquare", typeof(Views.modelSquare));
            Routing.RegisterRoute("ai", typeof(Views.AI));
            Routing.RegisterRoute("myself", typeof(Views.Myself));
        }
    }
}

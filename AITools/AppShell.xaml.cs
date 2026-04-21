namespace AITools
{
    public partial class AppShell : Shell
    {
        public AppShell()
        {
            InitializeComponent();

            // Make sure the route has been registered.
            Routing.RegisterRoute("modelsquare", typeof(Views.modelSquare));
            Routing.RegisterRoute("ai", typeof(Views.AI));
            Routing.RegisterRoute("myself", typeof(Views.Myself));
        }
    }
}

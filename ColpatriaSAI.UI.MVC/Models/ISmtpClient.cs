using System.Net.Mail;

namespace ColpatriaSAI.UI.MVC.Models
{
	public interface ISmtpClient
	{
		void Send(MailMessage mailMessage);
	}
}